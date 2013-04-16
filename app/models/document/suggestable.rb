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

        options[:facets]        = faceted_fields.slice(field)
        options[:query][field]  = term
        options[:global_facets] = true
        options[:per_page]      = 0 # dont fetch any documents

        options[:filter].delete(field)

        result = compose_search(options) do |index|
          search_facets(index)
        end

        format_facets(result.facets)[field]
      end

    end
  end
end
