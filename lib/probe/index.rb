module Probe
  module Index
    extend ActiveSupport::Concern

    module ClassMethods
      include Probe::Helpers::Index

      attr_reader :sort_fields, :per_page

      def setup
        settings
      end

      def configuration
        Probe::Configuration
      end

      def settings(params = {})
        settings = configuration.index

        settings.deep_merge!(params)

        tire.settings.deep_merge!(settings)

        index_name "#{index.name}_#{Rails.env}" unless Rails.env.production?

        tire.settings
      end

      def mapping
        unless block_given?
          return @mapping
        else
          @mapping     = Hash.new
          @sort_fields = Array.new

          yield

          tire.mapping do
            @mapping.each do |field, value|
              options  = value[:options]

              type       = options[:type]       || :string
              analyzer   = options[:analyzer]   || :text_analyzer
              as         = options[:as]         || lambda { |obj| obj.send(field) }
              suggest    = options[:suggest].nil? ? true : options[:suggest]
              suggester  = options[:suggester]  || method(:format_suggested_field)

              case value[:type]
              when :mapped
                indexes field, options.merge(index: :not_analyzed)
              when :analyzed
                indexes field, options.deep_merge(
                  type:   :multi_field,
                  fields: {
                    analyzed:   { type: :string,  analyzer: analyzer },
                    untouched:  { type: type,  index: :not_analyzed }
                  }
                )
              end

              if suggest
                indexes suggested_field(field), options.deep_merge(
                  type:  :string,
                  index: :not_analyzed,
                  as: lambda { |obj|
                    value = as.call(obj)

                    suggester.call(value)
                  }
                )
              end
            end
          end
        end
      end

      def facets
        @facet_definitions ||= []

        yield if block_given?

        @facets ||= Probe::Facets.new(@facet_definitions)
      end

      def per_page
        @_default_per_page || Probe::Configuration.per_page
      end

      private

      def map(field, options = {})
        @mapping[field]           = {}
        @mapping[field][:type]    = :mapped
        @mapping[field][:options] = options.merge! suggest: false
      end

      def analyze(field, options = {})
        @mapping[field]           = {}
        @mapping[field][:type]    = :analyzed
        @mapping[field][:options] = options
      end

      def nested(field, options = {}, &block)
        @mapping[field]           = {}
        @mapping[field][:type]    = :nested
        @mapping[field][:options] = options
        @mapping[field][:block]   = block
      end

      def facet(name, options = {})
        type  = options[:type]
        field = options[:field] || name

        field = mapping.keys if field == :all

        options.merge! base: self

        @facet_definitions << create_facet(type, name, field, options)
      end

      def sort_by(*args)
        @sort_fields = *args
      end
    end
  end
end
