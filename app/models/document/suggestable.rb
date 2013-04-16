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

        facet                   = faceted_fields[field]
        options[:facets]        = faceted_fields.slice(field)
        options[:query][field]  = term
        options[:global_facets] = true
        options[:per_page]      = 0 # dont fetch any documents

        options[:filter].delete(field)

        result = compose_search(options) do |index|
          facet_options = Hash.new

          facet_options[:global]       = true
          facet_options[:facet_filter] = facet_filter(@query, @terms)

          build_facet(index, field, field, facet, facet_options)
        end

        # TODO: use facet validator to exclude redundant facets
        format_facets(result.facets)[field]
      end

    end
  end
end
