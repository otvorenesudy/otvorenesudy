module Document
  module Suggestable
    extend ActiveSupport::Concern

    module ClassMethods
      include Document::Index::Helpers

      def suggest(name, term, options = {})
        options[:filter] ||= {}

        facet = @facets[name]

        suggest_facet = Document::Facets::FulltextFacet.new(suggested_facet_name(name), facet.field, {})

        suggest_facet.terms         = suggest_facet.parse(term)
        suggest_facet.query_options = { operator: :and, analyze_wildcard: true }

        options[:global_facets] = true
        options[:per_page]      = 0

        options[:filter].delete(name)

        defined_facets, result = compose_search(options) do |index, facets|
          facets = facets.merge(suggest_facet.name => suggest_facet)

          facet_options = {
            global:       true,
            facet_filter: build_facet_filter(facets)
          }

          build_facet(index, name, facet.field, facet, facet_options)
        end

        # TODO: use facet validator to exclude redundant facets
        format_facets(defined_facets, result.facets)[name]
      end

    end
  end
end
