module Document
  module Suggestable
    extend ActiveSupport::Concern

    module ClassMethods

      def suggest(field, term, options = {})
        options[:query] ||= {}

        facet = @facets[field]

        options[:query][field]  = term
        options[:global_facets] = true
        options[:per_page]      = 0 # dont fetch any documents

        options[:filter].delete(field)

        defined_facets, _, result = compose_search(options) do |index, query, facets|
          facet_options = Hash.new

          facet_options[:global]       = true
          facet_options[:facet_filter] = facet_filter(query, facets) do |q, f|
            build_suggest_query(q).concat(build_filter(:or, f))
          end

          build_facet(index, field, field, facet, facet_options)
        end

        # TODO: use facet validator to exclude redundant facets
        format_facets(defined_facets, result.facets)[field]
      end

    end
  end
end
