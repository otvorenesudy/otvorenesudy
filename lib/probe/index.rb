module Probe
  module Index
    extend ActiveSupport::Concern

    module ClassMethods
      include Probe::Helpers::Index

      attr_reader :sort_fields

      def setup
        @index_name = "#{name.underscore.pluralize}_#{Rails.env}"
      end

      def index_name
        @index_name
      end

      def create_index
        return if Probe.client.indices.exists?(index: index_name)

        Probe.client.indices.create(
          index: index_name,
          body: {
            settings: build_settings,
            mappings: { properties: build_mapping_properties }
          }
        )
      end

      def delete_index
        return unless Probe.client.indices.exists?(index: index_name)

        Probe.client.indices.delete(index: index_name)
      end

      def refresh_index
        Probe.client.indices.refresh(index: index_name)
      end

      def import_index
        delete_index
        create_index

        find_in_batches(batch_size: 500) do |batch|
          body = batch.flat_map { |r| [{ index: { _index: index_name, _id: r.id } }, r.to_indexed_hash] }
          Probe.client.bulk(body: body) if body.any?
        end

        refresh_index
      end

      def update_index
        find_each { |record| record.update_index }
        refresh_index
      end

      def reload_index
        delete_index
        create_index
        import_index
      end

      def total
        Probe.client.count(index: index_name)['count']
      rescue
        0
      end

      def mapping
        unless block_given?
          return @mapping || {}
        else
          @mapping = {}
          @sort_fields = []

          yield

          analyze :created_at, type: :date
          analyze :updated_at, type: :date

          @mapping
        end
      end

      def facets
        if block_given?
          @facet_definitions ||= []

          yield

          facet :created_at, type: :abstract, facet: :date, interval: :month
          facet :updated_at, type: :abstract, facet: :date, interval: :month

          @facets = Probe::Facets.new(@facet_definitions)
        end

        @facets
      end

      def per_page
        @_default_per_page || Probe::Configuration.per_page
      end

      def bulk_name
        "#{index_name}_#{Time.now.strftime('%Y%m%d%H%M')}"
      end

      def bulk(options = {})
        page(options[:page]).per(options[:per_page])
      end

      def distribute(relation)
        return [1..1] if relation.count.zero? || total.zero?
        x = 10**Math.log10(relation.count / total.to_f).to_i
        [1..(x / 2), (x / 2)..(x), (x)..(x * 2), (x * 2)..(x * 5), (x * 5)..(x * 10)].uniq
      rescue
        [1..1]
      end

      private

      def build_settings
        Probe::Configuration.index.to_h.deep_symbolize_keys
      end

      def build_mapping_properties
        (@mapping || {}).each_with_object({}) do |(field, opts), props|
          if opts[:kind] == :mapped
            props[field] = { type: :keyword }
          elsif opts[:kind] == :analyzed
            if opts[:type] == :date
              props[field] = { type: :date }
            elsif opts[:type] == :integer
              props[field] = { type: :integer }
            else
              props[field] = {
                type: :text,
                analyzer: opts[:analyzer] || :text_analyzer,
                fields: { raw: { type: :keyword } }
              }
            end
          end
        end
      end

      def map(field, options = {})
        @mapping[field] = options.merge(kind: :mapped)
      end

      def analyze(field, options = {})
        @mapping[field] = options.merge(kind: :analyzed)
      end

      def facet(name, options = {})
        type  = options[:type]
        field = options[:field] || name

        options.merge! base: self

        @facet_definitions << create_facet(type, name, field, options)
      end

      def sort_by(*args)
        @sort_fields = *args
      end
    end

    def update_index
      Probe.client.index(index: self.class.index_name, id: id, body: to_indexed_hash)
    end
  end
end
