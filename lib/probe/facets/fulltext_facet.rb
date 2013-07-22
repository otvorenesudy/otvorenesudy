class Probe::Facets
  class FulltextFacet < Probe::Facets::Facet
    include Probe::Search::Query

    attr_accessor :highlights,
                  :force_wildcard,
                  :query_options

    def initialize(name, field, options)
      super name, field, options

      @highlights     = options[:highlights] ? options[:highlights] : @field
      @force_wildcard = options[:force_wildcard]
    end

    def terms=(value)
      @terms = value
    end

    def build_query
      build_query_from(@field, @terms, query_options)
    end

    def build_query_filter
      build_query_filter_from(@field, @terms, query_options)
    end

    def parse_terms(value)
      value.respond_to?(:join) ? value.join(' ') : value.to_s if value.present?
    end

    private

    def query_options
      @query_options ||= { operator: :or, analyze_wildcard: true, force_wildcard: @force_wildcard }
    end
  end
end
