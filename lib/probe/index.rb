module Probe
  module Index
    extend ActiveSupport::Concern

    module ClassMethods
      include Probe::Helpers::Index

      attr_reader :sort_fields, :per_page

      def setup
        settings

        index_name "#{index_name}_#{Rails.env}"
      end

      def configuration
        Probe::Configuration
      end

      def index(name = nil)
        name ? Tire::Index.new(name) : tire.index
      end

      def index_alias(name = nil)
        Tire::Alias.new(name: name || index_name)
      end

      def settings(params = {})
        settings = configuration.index.to_hash

        settings.deep_merge!(params)

        tire.settings.deep_merge!(settings)

        tire.settings
      end

      def create_index(name = nil)
        index = index(name)

        index.create(mappings: tire.mapping_to_hash, settings: tire.settings) unless index.exists?

        index
      end

      def delete_index(name = nil)
        index(name).delete
      end

      def import_index
        Probe::Bulk.import(self)

        index.refresh
      end

      def update_index
        find_each { |record| record.update_index }

        index.refresh
      end

      def recheck_index
        find_each do |record|
          results = Tire.search(index_name) { |search| search.query { |query| query.string "id:#{record.id}" } }.results

          record.update_index if results.empty?
        end
      end

      def consolidate_index
        search = Tire.scan(index_name) { |s| s.fields ['id'] }
        ids_to_delete = []

        search.each_document { |document| ids_to_delete << document.id unless exists?(document.id) }

        unless ids_to_delete.empty?
          ids_to_delete.each_slice(1000) do |ids_slice|
            Tire::DeleteByQuery.new(index_name) { query { terms :_id, ids_slice } }
          end
        end

        index.refresh
      end

      def reload_index
        delete_index
        create_index

        import_index
      end

      # TODO: use when elasticsearch support percolating against index alias
      def alias_index_as(bulk_index)
        delete_index

        index = index_alias

        index.indices.clear
        index.index(bulk_index.name)

        index.save
      end

      def mapping
        unless block_given?
          return tire.mapping
        else
          @mapping = Hash.new
          @sort_fields = Array.new

          yield

          analyze :created_at, type: :date
          analyze :updated_at, type: :date

          tire.mapping do
            @mapping.each do |field, value|
              options = value[:options] || Hash.new

              type = options[:type] || :string
              analyzer = options[:analyzer] || :text_analyzer
              index = options[:index] || :not_analyzed

              case value[:type]
              when :mapped
                indexes field, options.merge(index: :not_analyzed)
              when :analyzed
                indexes field,
                        options.deep_merge(
                          type: :multi_field,
                          fields: {
                            analyzed: {
                              type: :string,
                              analyzer: analyzer,
                              include_in_all: true
                            },
                            untouched: {
                              type: type,
                              index: index
                            }
                          }
                        )
              end
            end
          end
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
        # TODO: requeries Kaminari. Drop or leave dependence?
        # TODO: rewrite with LIMIT & OFFSET?
        page(options[:page]).per(options[:per_page])
      end

      def total
        (tire.search { query { all } }).total
      end

      private

      def map(field, options = {})
        @mapping[field] = {}
        @mapping[field][:type] = :mapped
      end

      def analyze(field, options = {})
        @mapping[field] = {}
        @mapping[field][:type] = :analyzed
        @mapping[field][:options] = options
      end

      def nested(field, options = {}, &block)
        @mapping[field] = {}
        @mapping[field][:type] = :nested
        @mapping[field][:options] = options
        @mapping[field][:block] = block
      end

      def facet(name, options = {})
        type = options[:type]
        field = options[:field] || name

        options.merge! base: self

        @facet_definitions << create_facet(type, name, field, options)
      end

      def distribute(relation)
        return [1..1] if relation.count.zero? || total.zero?
        x = 10**Math.log10(relation.count / total.to_f).to_i
        [1..(x / 2), (x / 2)..(x), (x)..(x * 2), (x * 2)..(x * 5), (x * 5)..(x * 10)].uniq
      end

      def sort_by(*args)
        @sort_fields = *args
      end
    end
  end
end
