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

        options[:facets]       = @facets.slice(field)
        options[:query][field] = term
        options[:global_facets] = true

        options[:filter].delete(field)

        facets = format_facets(compose_search(options).facets)

        facets[field]
      end

    end
  end
end
