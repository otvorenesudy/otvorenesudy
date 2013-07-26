module Probe
  module Index
    extend ActiveSupport::Concern

    included do
      unless respond_to? :paginate
        def self.paginate(options = {})
          probe.paginate(self, options)
        end
      end
    end

    def probe
      @probe ||= Record.new(self)
    end

    module ClassMethods
      def probe(&block)
        @probe ||= Mapper.new(self)

        if block_given?
          @probe.instance_eval(&block)
        end

        @probe
      end
    end

    class Record
      attr_reader :record

      def initialize(record)
        @record = record
      end

      def id
        record.id
      end

      def type
        record.class.probe.type
      end

      def update
        record.class.probe.store(self)
      end

      def to_indexed_json
        record.to_indexed_json
      end
    end

    class Mapper
      include Probe::Helpers::Index

      attr_reader :base,
                  :name,
                  :type,
                  :sort_fields,
                  :per_page

      def initialize(base)
        @base = base
        @type = @base.respond_to?(:table_name) ? @base.table_name : @base.to_s.underscore
        @type = @type.singularize.to_sym
      end

      def name
        @name ||= "#{@type.to_s.pluralize}_#{Rails.env}"
      end

      def setup
        if base < ActiveRecord::Base
          base.after_save    :update_record
          base.after_destroy :update_record
        end

        define_proxy
      end

      def configuration
        Probe::Configuration
      end

      def index(index = nil)
        index ? Tire::Index.new(index) : @index ||= Tire::Index.new(name)
      end

      def index_alias(name = nil)
        Tire::Alias.new(name: name || index.name)
      end

      def settings(params = {})
        settings = configuration.index

        settings.deep_merge! params

        settings
      end

      def create(name = nil)
        index = index(name)

        index.create(mappings: mapping_to_hash, settings: settings) unless index.exists?

        index
      end

      def delete(name = nil)
        index(name).delete
      end

      def import(collection = nil, options = {})
        collection ? index.import(collection, options) : Probe::Bulk.import(base)
      end

      def update(collection = base)
        block = lambda { |record| record.probe.update }

        collection.respond_to?(:each) ? collection.each(&block) : collection.find_each(&block)
      end

      def reload
        delete
        create
        import
      end

      def store(record)
        index.store(record)
      end

      # TODO: use when elasticsearch support percolating against index alias
      def alias_as(bulk_index)
        delete

        index = index_alias

        index.indices.clear
        index.index(bulk_index.name)

        index.save
      end

      def mapping(options = {}, &block)
        unless block_given?
          return @mapping ||= Hash.new
        else
          @sort_fields         = Array.new
          @mapping_definitions = Hash.new

          mapping_options.merge! options

          update_mapping(&block).call

          @mapping_definitions.each do |field, value|
            options  = value[:options] || Hash.new

            type     = options[:type] || :string
            analyzer = options[:analyzer] || :text_analyzer

            case value[:type]
            when :map
              mapping.merge! field => options.merge(type: type, index: :not_analyzed)
            when :analyze
              analyzed  = { type: :string, analyzer: analyzer }
              untouched = { type: type, index: :not_analyzed }

              mapping.merge! field => options.deep_merge(
                type: :multi_field,
                fields: {
                  analyzed:  analyzed,
                  untouched: untouched
                }
              )
            end
          end
        end
      end

      def update_mapping(&block)
        if block_given?
          @mapping_block = lambda do
            block.call

            map     :id,         type: :long
            analyze :created_at, type: :date
            analyze :updated_at, type: :date
          end
        else
          mapping(&@mapping_block)

          index.put_mapping(*mapping_to_hash.first)
        end

        @mapping_block
      end

      def mapping_options
        @mapping_options ||= Hash.new
      end

      def mapping_to_hash
         { type.to_sym => mapping_options.merge({ properties: mapping }) }
      end

      def facets
        @facet_definitions ||= []

        yield if block_given?

        facet :created_at, type: :abstract, facet: :date, interval: :month
        facet :updated_at, type: :abstract, facet: :date, interval: :month

        @facets ||= Probe::Facets.new(@facet_definitions)
      end

      def per_page
        base.respond_to?(:default_per_page) ? base.default_per_page : Probe::Configuration.per_page
      end

      def bulk_name
        "#{index_name}_#{Time.now.strftime("%Y%m%d%H%M")}"
      end

      def total
        base.search { match_all }.total
      end

      def paginate(model, options = {})
        options[:page]     ||= 1
        options[:per_page] ||= 1000

        options[:page] -= 1

        model.offset(options[:per_page] * options[:page]).limit(options[:per_page])
      end

      private


      def map(field, options = {})
        @mapping_definitions[field] = Hash.new

        @mapping_definitions[field].merge! type: :map, options: options
      end

      def analyze(field, options = {})
        @mapping_definitions[field] = Hash.new

        @mapping_definitions[field].merge! type: :analyze, options: options
      end

      def facet(name, options = {})
        type  = options[:type]
        field = options[:field] || name

        options.merge! base: base

        @facet_definitions << create_facet(type, name, field, options)
      end

      def sort_by(*args)
        @sort_fields = *args
      end

      def define_proxy
        public_methods(false).each do |method|
          unless base.respond_to? method
            base.class_eval <<-def
              def self.#{method}(*args, &block)
                probe.send(#{method.inspect}, *args, &block)
              end
            def
          end
        end
      end
    end
  end
end
