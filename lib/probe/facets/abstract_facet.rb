# frozen_string_literal: true

module Probe
  class Facets
    # A facet that filters but isn't offered on the page: `created_at`/`updated_at` on every model, `exact_date` on
    # hearings. It behaves as the facet given in `facet:`, without an aggregation.
    class AbstractFacet < SimpleDelegator
      def initialize(name, field, options)
        super(Probe::Facets.create(options[:facet], name, field, options))
      end

      def buildable?
        false
      end

      def abstract?
        true
      end
    end
  end
end
