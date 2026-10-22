# frozen_string_literal: true

module Probe
  class Facets
    # A yes/no switch that filters through another facet: `value:` gives that facet's terms for the switch's state
    # (nil filters nothing). Hearings' `historical` switch is on by default (all hearings); off keeps those from now on.
    class BooleanFacet < Facet
      def initialize(name, field, options)
        super

        @facet = Probe::Facets.create(options[:facet], name, field, options)
        @facet_value = options[:value]
        @default = options[:default]

        self.terms = @default.nil? || @default
      end

      def terms=(value)
        @terms = value
        @facet.terms = facet_value
      end

      def value
        terms
      end

      # rubocop:disable-next Naming/PredicateMethod -- every facet type implements parse_terms
      def parse_terms(value)
        [true, 'true'].include?(value)
      end

      delegate :active?, to: :@facet

      delegate :filter, to: :@facet

      private

      def facet_value
        @facet_value.call(self)
      end
    end
  end
end
