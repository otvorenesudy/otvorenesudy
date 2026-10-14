# frozen_string_literal: true

module Probe
  module Converters
    # Date range params ("2015-01-01..2015-01-31") and date histogram keys (epoch milliseconds, UTC).
    module Date
      module_function

      def from_elastic(value)
        Time.at(value / 1000).utc.to_date
      end

      def to_elastic(value)
        ::Date.parse(value.to_s)
      end

      # Both ends inclusive, to the day.
      def to_elastic_range(range)
        { gte: range.begin.iso8601, lt: (range.end.to_date + 1).iso8601 }
      end
    end
  end
end
