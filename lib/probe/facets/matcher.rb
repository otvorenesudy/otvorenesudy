class Probe::Facets
  module Matcher
    private

    def match_query_facets(query, facets, options = {})
      size  = options[:size] || 10

      query = analyze_facet_match_value(query).split(/\s/)

      facets.each do |facet|
        next unless facet.results and facet.suggestable?

        facet.results = facet.results.find_all do |result|
          value = analyze_facet_match_value(result.value)

          query.all? { |q| value.include? q }
        end
      end
    end

    def analyze_facet_match_value(value)
      value.ascii.downcase
    end
  end
end
