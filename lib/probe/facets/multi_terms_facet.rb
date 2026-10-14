# frozen_string_literal: true

module Probe
  class Facets
    # A terms facet that carries a `multi:` option for its views.
    class MultiTermsFacet < TermsFacet
      attr_reader :multi

      def initialize(name, field, options)
        super

        @multi = options[:multi]
      end
    end
  end
end
