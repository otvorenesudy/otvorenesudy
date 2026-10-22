# frozen_string_literal: true

module Probe
  class Facets
    # Counts per calendar month, newest first. A selected month is a date range param: "2015-01-01..2015-01-31".
    class DateFacet < RangeFacet
      attr_reader :interval

      def initialize(name, field, options)
        super(name, field, options.merge(converter: Probe::Converters::Date))

        @interval = options[:interval]
      end

      def aggregation
        histogram = { field: keyword_field, calendar_interval: interval.to_s, min_doc_count: 1,
                      order: { _key: 'desc' } }

        { values: { date_histogram: histogram } }
      end

      private

      def build_results(response)
        response.dig('values', 'buckets').to_a.map { |bucket| result(period(bucket['key']), bucket['doc_count']) }
      end

      def period(key)
        date = Probe::Converters::Date.from_elastic(key)

        date.all_month
      end
    end
  end
end
