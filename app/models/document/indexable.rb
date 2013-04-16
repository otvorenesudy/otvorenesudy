module Document
  module Indexable

    def self.included(base)
      base.send(:extend,  ClassMethods)
      base.send(:include, Tire::Model::Search)
      base.send(:include, Tire::Model::Callbacks)

      base.configure
    end

    module ClassMethods

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

      def analyzed(field)
        "#{field}.analyzed".to_sym
      end

      def not_analyzed(field)
        "#{field}.untouched".to_sym
      end

      def selected(field)
        "#{field}_selected".to_sym
      end

      def selected?(field)
        field.to_s =~ /_selected/
      end

      def faceted_fields
        @faceted_fields ||= {}
      end

      def highlighted_fields
        @highlighted_fields ||= []
      end

      def mappings
        @mappings           ||= {}

        yield

        tire.mapping do
          @mappings.each do |field, value|
            options  = value[:options]

            type     = options[:type]     || :string
            analyzer = options[:analyzer] || 'text_analyzer'

            highlighted_fields << field if options[:highlight]

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

      def facets
        yield
      end

      private

      def map(field, options = {})
        @mappings[field] = {}

        @mappings[field][:type]    = :mapped
        @mappings[field][:options] = options
      end

      def analyze(field, options = {})
        @mappings[field] = {}

        @mappings[field][:type]    = :analyzed
        @mappings[field][:options] = options
      end

      def use(field, options = {})
        type = options[:type]

        # TODO: use core/injector?
        faceted_fields[field] = "Document::Faceted::#{type.to_s.camelcase}Facet".constantize.new(field, options)
      end

    end
  end
end
