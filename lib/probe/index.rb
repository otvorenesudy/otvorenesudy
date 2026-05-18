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
        raise NotImplementedError, 'Tire gem removed: implement with modern Elasticsearch client'
      end

      def index_alias(name = nil)
        raise NotImplementedError, 'Tire gem removed: implement with modern Elasticsearch client'
      end

      def settings(params = {})
        @_tire_settings ||= {}
        @_tire_settings.deep_merge!(configuration.index.to_hash)
        @_tire_settings.deep_merge!(params)
        @_tire_settings
      end

      def create_index(name = nil)
        raise NotImplementedError, 'Tire gem removed: implement with modern Elasticsearch client'
      end

      def delete_index(name = nil)
        raise NotImplementedError, 'Tire gem removed: implement with modern Elasticsearch client'
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
        raise NotImplementedError, 'Tire gem removed: implement with modern Elasticsearch client'
      end

      def consolidate_index
        raise NotImplementedError, 'Tire gem removed: implement with modern Elasticsearch client'
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
          return @mapping
        else
          @mapping = Hash.new
          @sort_fields = Array.new

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
        # TODO: requeries Kaminari. Drop or leave dependence?
        # TODO: rewrite with LIMIT & OFFSET?
        page(options[:page]).per(options[:per_page])
      end

      def total
        raise NotImplementedError, 'Tire gem removed: implement with modern Elasticsearch client'
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
