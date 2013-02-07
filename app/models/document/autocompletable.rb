module Document
  module Autocompletable
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods

      def autocomplete_field(field)
        if self.respond_to?(:analyzed_field)
          analyzed_field(field)
        else
          "#{field}_autocomplete".to_sym
        end
      end

      def autocomplete(field, options)
        options[:as] ||= "#{field}"

        mapping do
          indexes autocomplete_field(field), analyzer: 'autocomplete_analyzer', as: options[:as]
        end
      end

      def suggest(field, term, options = {})
        options[:search]         ||= {}
        options[:search][:query] ||= {}

        options[:search][:query][field] = term
        options[:search][:facets] = field

        facet(field, search(options).facets)
      end

    end
  end
end
