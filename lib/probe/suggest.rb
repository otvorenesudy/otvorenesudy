module Probe
  module Suggest
    extend ActiveSupport::Concern

    module ClassMethods
      include Probe::Helpers::Index
      include Probe::Facets::Matcher

      def suggest(name, term, params, options = {})
        facet = facets[name]

        return unless facet.suggestable?

        options[:name]        = index.name
        options[:params]      = params
        options[:facets]      = @facets
        options[:sort_fields] = @sort_fields

        search = Search::Composer.new(self, options)

        # TODO: use facet validator to validate facet results
        results = search.compose do
          filter = build_facet_filter(facet) || { and: [] }

          filter[:and] << facet.build_suggest_query(term)

          facet_options = {
            global_facets: false,
            facet_filter:  filter
          }

          facet.build(@index, facet.name, facet_options)

          if facet.active?
            facet_options = {
              global_facets: false,
              facet_filter:  build_search_filter
            }

            facet.build(@index, facet.selected_name, facet_options)
          end
        end

        match_query_facets(term, results.facets)

        results
      end
    end
  end
end
