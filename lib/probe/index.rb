module Probe
  module Index
    extend ActiveSupport::Concern

    included do
      probe.setup
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

      def mapper
        record.class.probe
      end

      def id
        record.id
      end

      def type
        mapper.type
      end

      def update
        mapper.store(self)
      end

      def to_indexed_json
        record.to_indexed_json
      end
    end

    class Mapper
      include Probe::Index::Alias
      include Probe::Helpers::Index

      attr_reader :base,
                  :name,
                  :type,
                  :sort_fields,
                  :per_page

      def initialize(base)
        @base = base
        @type = @base.respond_to?(:table_name) ? @base.table_name : @base.to_s.underscore

        @type = @type.to_sym
      end

      def name
        @name ||= "#{@type.to_s.pluralize}_#{Rails.env}"
      end

      def setup
        if base < ActiveRecord::Base
          base.after_save    { probe.update }
          base.after_destroy { probe.update }
        end

        define_proxy
      end

      def configuration
        Probe::Configuration
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

      def exists?(name = nil)
        index(name).exists?
      end

      def import(name = nil, collection = base)
        index(name).import(collection, method: :paginate, per_page: 5000)

        refresh
      end

      def update(collection = base)
        block = lambda { |record| record.probe.update }

        collection.respond_to?(:each) ? collection.each(&block) : collection.find_each(&block)
      end

      def reload(name = nil)
        delete(name)
        create(name)

        import
      end

      def refresh(name = nil)
        index(name).refresh
      end

      def store(record)
        index.store(record)
      end

      def mapping(options = {}, &block)
        return @mapping ||= Hash.new unless block_given?

        @mapping_definitions = Hash.new

        mapping_options.merge! options

        update_mapping(&block)

        block.arity > 0 ? block.call(self) : instance_eval(&block)

        @mapping_definitions.each do |field, value|
          options  = value[:options] || Hash.new

          type     = options[:type]     || :string
          analyzer = options[:analyzer] || Configuration.default_analyzer

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

      def update_mapping(&block)
        if block_given?
          @mapping_block = block
        else
          mapping(&@mapping_block)

          index.put_mapping(*mapping_to_hash.first)
        end
      end

      def mapping_options
        @mapping_options ||= Hash.new
      end

      def mapping_to_hash
         { type.to_sym => mapping_options.merge({ properties: mapping }) }
      end

      def facets(&block)
        return @facets ||= Probe::Facets.new unless block_given?

        block.arity > 0 ? block.call(self) : instance_eval(&block)
      end

      def per_page
        base.respond_to?(:default_per_page) ? base.default_per_page : Probe::Configuration.per_page
      end

      def total
        base.search { match_all }.total
      end

      def paginate(collection, options = {})
        options[:page]     ||= 1
        options[:per_page] ||= 1000

        options[:page] -= 1

        collection.offset(options[:per_page] * options[:page]).limit(options[:per_page])
      end

      private

      def index(index = nil)
        index ? Tire::Index.new(index) : @index ||= Tire::Index.new(name)
      end

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

        facets << create_facet(type, name, field, options)
      end

      def sort_by(*args)
        @sort_fields ||= Array.new

        @sort_fields += args
      end

      def define_proxy
        @proxy_methods ||= [:settings, :mapping, :facets, :configuration, :total, :paginate, :sort_by]

        @proxy_methods.each do |method|
          unless base.respond_to? method
            if method == :paginate
              base.class_eval do
                def self.paginate(options)
                  probe.paginate(self, options)
                end
              end
            else
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
end
