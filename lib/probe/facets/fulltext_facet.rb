class Probe::Facets
  class FulltextFacet < Probe::Facets::Facet
    include Probe::Search::Query

    attr_accessor :highlights,
                  :force_wildcard,
                  :query_options

    def initialize(name, field, options)
      super(name, field, options)

      @highlights     = options[:highlights]
      @force_wildcard = options[:force_wildcard]
    end

    def terms=(value)
      @terms = value
    end

    def highlights
      @highlights ||= field
    end

    def build_query
      { must: build_query_from(field, terms, query_options) }
    end

    def parse_terms(value)
      value.respond_to?(:join) ? value.join(' ') : value.to_s if value.present?
    end

    private

    def query_options
      @query_options ||= { default_operator: :or, analyze_wildcard: true, force_wildcard: force_wildcard }
    end
  end
end
