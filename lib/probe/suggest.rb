# frozen_string_literal: true

module Probe
  # `Model.suggest(:court, 'kos', params)`: the values of one facet that contain the typed term, regardless of case and
  # diacritics, within the listing's other facets. Returns the facets with that facet populated, or nil when the facet
  # takes no suggestions.
  module Suggest
    extend ActiveSupport::Concern

    class_methods do
      def suggest(name, term, params = {})
        facets = self.facets.extract_params(params.to_h.with_indifferent_access)
        facet = facets[name]

        return unless facet&.suggestable?

        response = client.search(index: index_name, body: suggest_body(facets, facet, term))
        aggregations = response['aggregations']

        facet.populate('values' => aggregations['values'], 'selected' => aggregations.dig('all', 'scoped', 'selected'))
        facets
      end

      private

      def suggest_body(facets, facet, term)
        queries = facets.queries
        queries += [facet.suggest_query(term)] if term.present?

        query = { bool: { must: queries.presence || [{ match_all: {} }], filter: facets.filters(except: facet) } }
        aggs = { values: facet.suggest_aggregation(term) }
        aggs[:all] = selected_aggregation(facets, facet) if facet.active?

        { size: 0, query:, aggs: }
      end

      # The selected values, counted under the whole search but not the typed term, so they stay listed.
      def selected_aggregation(facets, facet)
        filter = { bool: { must: facets.queries.presence || [{ match_all: {} }], filter: facets.filters } }

        { global: {}, aggs: { scoped: { filter:, aggs: { selected: facet.aggregation[:selected] } } } }
      end
    end
  end
end
