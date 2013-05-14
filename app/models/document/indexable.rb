module Document
  module Indexable

    def self.included(base)
      base.send(:extend,  ClassMethods)
      base.send(:include, Tire::Model::Search)
      base.send(:include, Tire::Model::Callbacks)

      base.configure
    end

    module ClassMethods
      include Document::Index::Helpers

      def config
        YAML.load_file(File.join(Rails.root, 'config', 'elasticsearch.yml')).symbolize_keys
      end

      def configure(params = {})
        settings = config[:index]

        settings.deep_merge!(params)

        tire.settings.deep_merge!(settings)
      end

      def mapping
        @mapping      ||= {}
        @highlights   ||= []
        @dependencies ||= {}

        unless block_given?
          return @mapping, @highlights
        else
          yield

          tire.mapping do
            @mapping.each do |field, value|
              options  = value[:options]

              type     = options[:type]     || :string
              analyzer = options[:analyzer] || 'text_analyzer'

              @highlights << field if options[:highlight]

              if options[:depends]
                dependencies(field, options)

                options.delete(:depends_on)
              end

              if value[:type].eql? :mapped
                indexes field, options.merge!(index: :not_analyzed)
              else
                indexes field, options.deep_merge!(
                  type:   :multi_field,
                  fields: {
                    analyzed:  { type: type,  analyzer: analyzer },
                    untouched: { type: type,  index: :not_analyzed }
                  }
                )
              end

            end
          end
        end
      end

      def facets
        @facets ||= {}

        if block_given?
          yield
        else
          @facets
        end
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

      def facet(name, options = {})
        type = options[:type]

        field = options[:field] || name

        # TODO: use core injector
        @facets[name] = "Document::Facets::#{type.to_s.camelcase}Facet".constantize.new(name,field, options)
      end

      def dependencies(field, options)
        dependent = options[:depends][:on]

        @dependencies[field]              = {}
        @dependencies[field][dependent] ||= {}

        dependencies = @dependencies[field]

        find_each do |record|
          value       = options[:as] ? options[:as].call(record) : record.send(field)
          dependency  = options[:depends][:as].call(record)

          dependencies[dependent][value] ||= []
          dependencies[dependent][value] << dependency unless dependencies[dependent][value].include?(dependency)
        end
      end

    end
  end
end
