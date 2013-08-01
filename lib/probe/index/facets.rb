class Probe::Index
  module Facets
    include Probe::Helpers

    def facets(&block)
      return @facets ||= Probe::Facets.new unless block_given?

      block.arity > 0 ? block.call(self) : instance_eval(&block)
    end

    private

    def facet(name, options = {})
      type  = options[:type]
      field = options[:field] || name

      options.merge! base: base

      facets << create_facet(type, name, field, options)
    end
  end
end
