# frozen_string_literal: true

module Probe
  module Converters
    # Numeric range params: "5..9", "-Infinity..4", "10..Infinity". A number the index can't hold (its fields are
    # integers) is unreadable, as "abc" is.
    module Numeric
      LIMIT = (2**31) - 1

      module_function

      def to_elastic(value)
        case value
        when 'Infinity' then Float::INFINITY
        when '-Infinity' then -Float::INFINITY
        else integer(value.to_i)
        end
      end

      def integer(value)
        raise ArgumentError, "#{value} is beyond the index's integers" if value.abs > LIMIT

        value
      end

      def to_elastic_range(range)
        bounds = {}
        bounds[:gte] = range.begin if range.begin > -Float::INFINITY
        bounds[:lte] = range.end if range.end < Float::INFINITY
        bounds
      end
    end
  end
end
