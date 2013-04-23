module Document
  module Indexable

    def self.included(base)
      base.send(:extend,  ClassMethods)
      base.send(:include, Tire::Model::Search)
      base.send(:include, Tire::Model::Callbacks)

      base.configure
    end

    module ClassMethods
      attr_reader :facets

      def config
        YAML.load_file(File.join(Rails.root, 'config', 'elasticsearch.yml')).symbolize_keys
      end

      def configure(params = {})
        settings = config[:index]

        settings.deep_merge!(params)

        tire.settings.deep_merge!(settings)
      end

      def field(name)
        name.sub(/\.(analyzed|untouched)/, '').to_sym
      end

      def analyzed_field(field)
        "#{field}.analyzed".to_sym
      end

      def not_analyzed_field(field)
        "#{field}.untouched".to_sym
      end

      def selected_field(field)
        "#{field}_selected".to_sym
      end

      def selected_field?(field)
        field.to_s =~ /_selected/
      end

      def has_field?(field)
        @mappings[field].present?
      end

      def has_facet?(name)
        @facets[name].present?
      end

      def use_mapping
        @mapping    ||= {}
        @highlights ||= []

        yield

        tire.mapping do
          @mapping.each do |field, value|
            options  = value[:options]

            type     = options[:type]     || :string
            analyzer = options[:analyzer] || 'text_analyzer'

            @highlights << field if options[:highlight]

            if value[:type].eql? :mapped
              indexes field, options.merge!(index: :not_analyzed)
            else
              indexes field, options.deep_merge!(
                  type:   'multi_field',
                  fields: {
                    analyzed:  { type: type,  analyzer: analyzer },
                    untouched: { type: type,  index: :not_analyzed }
                  }
              )
            end

          end
        end
      end

      def use_facets
        @facets ||= {}

        yield
      end

      private

      def map(field, options = {})
        @mapping[field] = {}

        @mapping[field][:type]    = :mapped
        @mapping[field][:options] = options
      end

      def analyze(field, options = {})
        @mapping[field] = {}

        @mapping[field][:type]    = :analyzed
        @mapping[field][:options] = options
      end

      def facet(field, options = {})
        type = options[:type]

        # TODO: use core injector
        @facets[field] = "Document::Facets::#{type.to_s.camelcase}Facet".constantize.new(field, not_analyzed_field(field), options)
      end

    end
  end
end
