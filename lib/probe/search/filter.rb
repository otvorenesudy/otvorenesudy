module Probe::Search
  module Filter
    def build_filter_from(type, facets)
      facets.values.flat_map { |facet| facet.build_filter if facet.terms? }.compact
    end
  end
end
