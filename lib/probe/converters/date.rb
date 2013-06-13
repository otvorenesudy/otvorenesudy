module Probe::Converters
  class Date
    def self.from_elastic(value)
      Time.at(value/1000).to_date
    end

    def self.to_elastic(value)
      ::Date.parse(value.to_s)
    end

    def self.to_elastic_range(value)
      { gte: value.min, lt: value.max }
    end
  end
end
