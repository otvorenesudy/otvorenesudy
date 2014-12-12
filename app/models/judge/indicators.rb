class Judge
  module Indicators
    extend ActiveSupport::Concern

    def indicators
      Judge::Indicators.for(self)
    end

    def self.for(judge)
      load! unless @data

      @data[judge.id]
    end

    def self.load!
      @data = Hash.new

      CSV.read(Rails.root.join('data', 'judge_indicators.csv'), col_sep: "\t", headers: true).each do |line|
        judge = Judge.find_by_name(line[0])

        @data[judge.id] = normalize_values(line) if judge
      end
    end

    def self.normalize_values(values)
      values.each_with_index do |(key, value), index|
        value.gsub!(/-/, '–')

        value = case value
                when 'N/A' then nil
                else value
                end

        if value
          value = case index
                  when 4, 5, 6 then value.split(',').map { |name| Court.find_by_name(name.strip) }
                  else value
                  end
        end

        values[key] = value
      end
    end
  end
end
