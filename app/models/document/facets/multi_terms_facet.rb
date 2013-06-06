module Document::Facets
  class MultiTermsFacet < Document::Facets::TermsFacet
    attr_reader :multi

    def initialize(name, field, options)
      super(name, field, options)

      @multi = options[:multi]
    end
  end
end
