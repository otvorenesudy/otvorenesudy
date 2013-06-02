module Document::Converters
  class Date
    def self.from_elastic(value)
      Time.at(value/1000)
    end

    def self.to_elastic(value)
      Time.at(value.to_i)
    end
  end
end
