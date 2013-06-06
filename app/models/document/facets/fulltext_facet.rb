module Document::Facets
  class FulltextFacet < Document::Facets::Facet
    include Document::Search::Query

    attr_accessor :query_options

    def initialize(name, field, options)
      super name, field, options.merge!(abstract: true)
    end

    def build_query
      build_query_from(@field, @terms, query_options)
    end

    def build_filter
      [build_query_filter_from(@field, @terms, query_options)]
    end

    def parse(value)
      value.respond_to?(:join) ? value.join(' ') : value.to_s
    end

    private

    def query_options
      @query_options ||= { operator: :or, analyze_wildcard: true }
    end
  end
end
