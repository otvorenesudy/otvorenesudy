# TODO: refactor to Nested facet, create facet groups

class Probe::Facets
  class BooleanFacet < Probe::Facets::Facet
    def initialize(name, field, options)
      super name, field, options

      @facet       = create_facet(options[:facet], name, field, options)
      @facet_value = options[:value]
    end

    def refresh!
      super

      @terms       = true
      @facet.terms = facet_value
    end

    def terms=(value)
      @terms = value

      @facet.terms = facet_value
    end

    def active?
      @facet.terms.present?
    end

    def parse_terms(value)
      value == true || value == 'true' ? true : false
    end

    def build_filter
      @facet.build_filter
    end

    alias :value :terms

    private

    def facet_value
      return @facet_value.call(self) if @facet_value.respond_to? :call

      @facet_value
    end
  end
end
