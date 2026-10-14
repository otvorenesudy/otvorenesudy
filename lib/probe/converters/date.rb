# frozen_string_literal: true

module Probe
  module Converters
    # Date range params ("2015-01-01..2015-01-31") and date histogram keys (epoch milliseconds, UTC).
    module Date
      module_function

      def from_elastic(value)
        Time.at(value / 1000).utc.to_date
      end

      # A date the index can't hold (a year beyond 1 to 9999) is unreadable, as "abc" is.
      def to_elastic(value)
        date = ::Date.parse(value.to_s)

        raise ArgumentError, "#{value} is beyond the index's years" unless (1..9999).cover?(date.year)

        date
      end

      # Both ends inclusive, to the day.
      def to_elastic_range(range)
        { gte: range.begin.iso8601, lt: (range.end.to_date + 1).iso8601 }
      end
    end
  end
end
