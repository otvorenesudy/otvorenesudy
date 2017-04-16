class Judge
  module Indicators2015
    extend ActiveSupport::Concern
    extend JusticeGovSk::Helper::Normalizer

    included do
      mapping do
        analyze :indicators_2015, as: lambda { |j|
          !!(j.indicators_2015 && j.indicators_2015.statistical && j.indicators_2015.numerical)
        }

        analyze :decree_agenda_2015, as: lambda { |j|
          if j.indicators_2015 && j.indicators_2015.statistical
            {
              'Občianska' => j.indicators_2015.statistical['C.assigned.agenda'].to_i,
              'Obchodná' => j.indicators_2015.statistical['Cb.assigned.agenda'].to_i,
              'Poručenská' => j.indicators_2015.statistical['P.assigned.agenda'].to_i,
              'Trestná' => j.indicators_2015.statistical['Trest.assigned.agenda'].to_i
            }.sort_by { |_, v| v }.last
          end
        }
      end

      facets do
        facet :name,                type: :terms, visible: false, view: { results: 'judges/indicators/facets/name_results' }
        facet :similar_courts,      type: :terms, field: :courts, visible: false, view: { results: 'judges/indicators/facets/terms_results' }
        facet :indicators_2015,     type: :terms, visible: false
        facet :decree_agenda_2015,  type: :terms, visible: false
      end

      Judge::Indicators2015.load!
    end

    def indicators_2015
      Judge::Indicators2015.for(self)
    end

    def self.for(judge)
      @data[judge.id]
    end

    def self.load!
      @data = Hash.new
      @numerical_average = nil

      CSV.read(Rails.root.join('judge-statistical-indicators-2015.csv'), col_sep: ',', headers: true).each do |line|
        judge = Judge.find_by_name(line[1].strip)

        next unless judge

        @data[judge.id] ||= OpenStruct.new
        @data[judge.id].statistical = normalize_statistical_values(line)
      end

      CSV.read(Rails.root.join('judge-numerical-indicators-2015.csv'), col_sep: ',', headers: true).each do |line|
        judge = Judge.find_by_name(line[1].strip)

        next unless judge

        @data[judge.id] ||= OpenStruct.new
        @data[judge.id].numerical = normalize_numerical_values(line)
      end
    end

    def self.numerical_average
      load! unless @data

      @numerical_average ||= calculate_numerical_average
    end

    def self.calculate_numerical_average
      average = Hash.new(0)

      @data.each do |_, values|
        next unless values.numerical
        next unless values.numerical.to_hash.values.compact != values.numerical.to_hash

        values.numerical.each do |key, value|
          average[key] += value if value
        end
      end

      average.each do |key, value|
        average[key] = (value / @data.size.to_f).round(1)
      end

      average
    end

    def self.normalize_statistical_values(values)
      values.each_with_index do |(key, value), _|
        next unless value

        value = Court.find_by_name(normalize_court_name(value)) if key.in?(%w(court))

        values[key] = value.presence
      end
    end

    def self.normalize_numerical_values(values)
      values.each_with_index do |(key, value), index|
        value = index.in?(2..9) ? value.to_i : nil

        values[key] = value
      end
    end
  end
end
