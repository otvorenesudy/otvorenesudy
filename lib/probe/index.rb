# frozen_string_literal: true

module Probe
  # A model's index: its mapping and facets, and the index's life. The index name (courts_production) is an alias of
  # the concrete index built last (courts_production_20261014101500000), so `reindex` fills a new index while the old
  # one serves searches, then switches the alias at once.
  module Index
    extend ActiveSupport::Concern

    BATCH_SIZE = 1000

    # Saving a record updates its document after the transaction commits. Elasticsearch being away must not fail the
    # save: the error goes to Sentry, and the nightly recheck_index restores the missing documents.
    INDEX_ERRORS = [Elastic::Transport::Transport::Error, Faraday::Error].freeze

    included do
      after_commit :update_index, on: %i[create update]
      after_commit :remove_from_index, on: :destroy
    end

    class_methods do
      def index_name
        "#{model_name.plural}_#{Rails.env}"
      end

      delegate :client, to: :Probe

      def mapping
        return probe_mapping unless block_given?

        yield

        analyze :created_at, type: :date
        analyze :updated_at, type: :date

        probe_mapping
      end

      delegate :sort_fields, to: :probe_mapping

      def per_page
        default_per_page || Probe::Configuration.per_page
      end

      def facets
        if block_given?
          yield

          facet :created_at, type: :abstract, facet: :date, interval: :month
          facet :updated_at, type: :abstract, facet: :date, interval: :month
        end

        Probe::Facets.build(self, facet_definitions.values)
      end

      def total
        client.count(index: index_name)['count']
      end

      def ensure_index
        return if client.indices.exists_alias?(name: index_name)

        delete_index
        switch_alias(create_index)
      end

      def create_index(name = "#{index_name}_#{Time.current.strftime('%Y%m%d%H%M%S%L')}")
        client.indices.create(index: name, body: { settings: Probe::Configuration.settings, mappings: mapping.to_h })

        name
      end

      def delete_index
        (alias_targets + [index_name]).uniq.each do |name|
          client.indices.delete(index: name, ignore_unavailable: true)
        end
      end

      def refresh_index
        client.indices.refresh(index: index_name)
      end

      # Builds a new index from the database and switches the alias to it.
      def reindex
        name = create_index

        import(name)
        client.indices.refresh(index: name)
        switch_alias(name)
      end

      alias_method :import_index, :reindex

      def reload_index
        delete_index
        reindex
      end

      # Updates every document in the current index, without a new one.
      def update_index
        ensure_index
        import(index_name)
        refresh_index
      end

      # Indexes the records missing from the index.
      def recheck_index
        ensure_index

        in_batches(of: BATCH_SIZE) do |batch|
          ids = batch.ids
          found = client.mget(index: index_name, body: { ids: }, _source: false)['docs'].select { |doc| doc['found'] }

          missing = ids - found.map { |doc| doc['_id'].to_i }
          bulk_index(index_name, where(id: missing)) if missing.any?
        end

        refresh_index
      end

      # Deletes the documents of records no longer in the database.
      def consolidate_index
        ids = Set.new(pluck(:id))

        each_document_id do |batch|
          stale = batch.reject { |id| ids.include?(id.to_i) }

          client.bulk(body: stale.map { |id| { delete: { _index: index_name, _id: id } } }) if stale.any?
        end

        refresh_index
      end

      def bulk_index(name, records)
        body = records.flat_map { |record| [{ index: { _index: name, _id: record.id } }, record.to_indexed_hash] }
        response = client.bulk(body:)

        return unless response['errors']

        failure = response['items'].find { |item| item.dig('index', 'error') }['index']

        raise Probe::IndexError, "#{name}/#{failure['_id']}: #{failure['error']}"
      end

      private

      def probe_mapping
        @probe_mapping ||= Probe::Mapping.new
      end

      def facet_definitions
        @facet_definitions ||= {}
      end

      def map(field, **)
        probe_mapping.map(field, **)
      end

      def analyze(field, **)
        probe_mapping.analyze(field, **)
      end

      def sort_by(*)
        probe_mapping.sort_by(*)
      end

      def facet(name, type:, field: name, **options)
        facet_definitions[name.to_sym] = [type, name.to_sym, field, options.merge(type:, base: self)]
      end

      # Ranges for a facet counting related records (hearings per court), around the average count. Computed when a
      # search first needs them and cached for a day.
      def distribute(relation)
        lambda do
          Rails.cache.fetch(['probe', 'distribution', name, relation.name], expires_in: 1.day) do
            Probe::Index.distribution(relation.count, total)
          end
        end
      end

      def import(name)
        in_batches(of: BATCH_SIZE) { |batch| bulk_index(name, batch) }
      end

      def alias_targets
        client.indices.get_alias(name: index_name).keys
      rescue Elastic::Transport::Transport::Errors::NotFound
        []
      end

      def switch_alias(name)
        targets = alias_targets
        client.indices.delete(index: index_name) if targets.empty? && client.indices.exists?(index: index_name)

        actions = targets.map { |target| { remove: { index: target, alias: index_name } } }
        client.indices.update_aliases(body: { actions: actions + [{ add: { index: name, alias: index_name } }] })

        (targets - [name]).each { |target| client.indices.delete(index: target) }
      end

      def each_document_id
        pit = client.open_point_in_time(index: index_name, keep_alive: '1m')['id']
        after = nil

        loop do
          body = { size: BATCH_SIZE, pit: { id: pit, keep_alive: '1m' }, sort: ['_shard_doc'], _source: false }
          body[:search_after] = after if after
          hits = client.search(body:)['hits']['hits']

          break if hits.empty?

          yield hits.pluck('_id')
          after = hits.last['sort']
        end
      ensure
        client.close_point_in_time(body: { id: pit }) if pit
      end
    end

    def self.distribution(count, total)
      return [1..1] if count.zero? || total.zero?

      x = 10**Math.log10(count / total.to_f).to_i

      [1..(x / 2), (x / 2)..x, x..(x * 2), (x * 2)..(x * 5), (x * 5)..(x * 10)].uniq
    end

    def update_index
      Rails.error.handle(*INDEX_ERRORS) do
        self.class.ensure_index
        self.class.client.index(index: self.class.index_name, id:, body: to_indexed_hash)
      end
    end

    def remove_from_index
      Rails.error.handle(*INDEX_ERRORS) do
        self.class.client.delete(index: self.class.index_name, id:)
      rescue Elastic::Transport::Transport::Errors::NotFound
        nil
      end
    end
  end
end
