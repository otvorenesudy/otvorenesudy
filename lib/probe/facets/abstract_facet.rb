class Probe::Facets
  class AbstractFacet
    include Probe::Helpers::Index

    def initialize(name, field, options)
      @facet = create_facet(options[:facet], name, field, options)
    end

    def buildable?
      false
    end

    def abstract?
      true
    end

    def respond_to?(*args)
      @facet.respond_to?(*args)
    end

    def method_missing(method, *args, &block)
      if @facet.respond_to? method.to_sym
        @facet.send(method, *args, &block)
      else
        super(method, *args, &block)
      end
    end
  end
end
