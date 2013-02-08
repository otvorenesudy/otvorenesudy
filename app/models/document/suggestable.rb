module Document
  module Suggestable
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      # TODO: implement facet_filter to filter facets according to specified
      # query
      
      def suggest(field, term, options = {})
        options[:query] ||= {}

        options[:query][field] = term
        options[:facets]       = field

        facets = format_facets(compose_search(options).facets)

        facets[field]
      end

    end
  end
end
