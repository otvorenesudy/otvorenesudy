class Probe::Facets
  class MultiTermsFacet < Probe::Facets::TermsFacet
    attr_reader :multi

    def initialize(name, field, options)
      super(name, field, options)

      @multi = options[:multi]
    end
  end
end
