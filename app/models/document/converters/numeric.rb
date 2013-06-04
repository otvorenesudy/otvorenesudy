module Document::Converters
  class Numeric
    def self.to_elastic(value)
      case value
      when 'Infinity'  then  Float::INFINITY
      when '-Infinity' then -Float::INFINITY
      else                   value.to_i
      end
    end

    def self.to_elastic_range(value)
      range = Hash.new

      range[:gte] = value.min if value.min > -Float::INFINITY
      range[:lt]  = value.max if value.max <  Float::INFINITY

      range
    end
  end
end
