# frozen_string_literal: true

module Probe
  class Facets
    # Full text over the analyzed fields (`field: :all` for every one), all words required. Its matches are highlighted
    # in the `highlights` fields, by default the searched ones.
    class FulltextFacet < Facet
      attr_reader :highlights

      def initialize(name, field, options)
        super

        @highlights = options[:highlights] || field
        @force_wildcard = options[:force_wildcard]
      end

      attr_writer :terms

      def parse_terms(value)
        return if value.blank?

        value.respond_to?(:join) ? value.join(' ') : value.to_s
      end

      def query(escape: :syntax)
        value = Probe::Sanitizer.query_string(terms, escape:)
        value = "#{value}*" if @force_wildcard

        fields = Array.wrap(analyzed_field)

        { query_string: { query: value, fields:, default_operator: 'AND', analyze_wildcard: true } }
      end
    end
  end
end
