module Document::Converters
  class Numeric
    def self.to_elastic(value)
      case value
      when 'Infinity'  then  Float::INFINITY
      when '-Infinity' then -Float::INFINITY 
      else                   value.to_i
      end
    end
  end
end
