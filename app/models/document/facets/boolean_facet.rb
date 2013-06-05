# TODO: refactor to Nested facet, create facet groups

module Document::Facets
  class BooleanFacet < Document::Facets::Facet
    def initialize(name, field, options)
      super(name, field, options.merge!(abstract: true))

      @facet       = create_facet(options[:facet], name, field, options)
      @facet_value = options[:value]
    end

    def refresh!
      super

      @terms       = false
      @facet.terms = facet_value
    end

    def terms=(value)
      super(value)

      @facet.terms = facet_value if @terms == true
    end

    def terms?
      @facet.terms.present?
    end

    def parse(value)
      value == 'true' ? true : false
    end

    def build_filter
      @facet.build_filter
    end

    private

    def facet_value
      return @facet_value.call(self) if @facet_value.respond_to? :call

      @facet_value
    end
  end
end
