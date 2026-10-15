# frozen_string_literal: true

module Probe
  class Facets
    # Counts within ranges (5..9 judges), plus everything below the first range and above the last. Ranges may be given
    # as a lambda (see Probe::Index#distribute), resolved when a search needs them.
    class RangeFacet < Facet
      class Result < Facet::Result
        def range
          value
        end
      end

      def initialize(name, field, options)
        super

        @ranges = options[:ranges]
        @converter = options[:converter] || Probe::Converters::Numeric
      end

      def ranges
        @ranges.respond_to?(:call) ? @ranges.call : @ranges
      end

      # Values the facet can't read, like "abc..", are left out.
      def parse_terms(values)
        super do |value|
          next value if value.is_a?(Range)

          lower, upper = value.to_s.split('..', 2)
          @converter.to_elastic(lower)..@converter.to_elastic(upper)
        rescue ArgumentError
          nil
        end.compact
      end

      def filter
        clauses = terms.map { |range| { range: { keyword_field => @converter.to_elastic_range(range) } } }

        { bool: { should: clauses, minimum_should_match: 1 } }
      end

      def aggregation
        { values: { range: { field: keyword_field, ranges: bucket_ranges } } }
      end

      private

      # Ranges are inclusive (5..9); Elasticsearch's are open at the top, so each ends one above.
      def bucket_ranges
        bounds = ranges

        [{ to: bounds.first.begin }] + bounds.map { |range| { from: range.begin, to: range.end + 1 } } +
          [{ from: bounds.last.end }]
      end

      def build_results(response)
        response.dig('values', 'buckets').to_a.filter_map do |bucket|
          result(format_range(bucket['from'], bucket['to']), bucket['doc_count']) if bucket['doc_count'].positive?
        end
      end

      def format_range(from, to)
        if from.nil?
          -Float::INFINITY..(to.to_i - 1)
        elsif to.nil?
          from.to_i..Float::INFINITY
        else
          from.to_i..(to.to_i - 1)
        end
      end
    end
  end
end
