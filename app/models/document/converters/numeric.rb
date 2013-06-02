module Document::Converters
  class Numeric
    def self.to_elastic(value)
      value.to_i
    end
  end
end
