class Judge
  module Indicators
    extend ActiveSupport::Concern
    extend JusticeGovSk::Helper::Normalizer

    included do
      mapping do
        analyze :has_indicators, as: lambda { |j| !!j.indicators && !!j.indicators.statistical && !!j.indicators.numerical }
        analyze :decree_agenda, as: lambda { |j|
          if j.indicators && j.indicators.statistical
            indicators = j.indicators.statistical

            map = {
              'Občianska' => indicators['S5a'].to_i,
              'Obchodná' => indicators['S5b'].to_i,
              'Poručenská' => indicators['S5c'].to_i,
              'Trestná' => indicators['S5d'].to_i
            }

            map.sort_by { |_, value| value }.last[0]
          end
        }
      end

      facets do
        facet :name, type: :terms, visible: false, view: { results: 'judges/indicators/terms_facet_results' }
        facet :indicators_courts, type: :terms, field: :courts, visible: false, view: { results: 'judges/indicators/terms_facet_results' }
        facet :decree_agenda, type: :terms, visible: false
        facet :has_indicators, type: :terms, visible: false
      end

      Judge::Indicators.load!
    end

    def indicators
      Judge::Indicators.for(self)
    end

    def self.for(judge)
      @data[judge.id]
    end

    def self.load!
      @data = Hash.new
      @numerical_average = nil

      CSV.read(Rails.root.join('data', 'judge_statistical_indicators.csv'), col_sep: "\t", headers: true).each do |line|
        judge = Judge.find_by_name(line[0])

        next unless judge

        @data[judge.id] ||= OpenStruct.new
        @data[judge.id].statistical = normalize_statistical_values(line)
      end

      CSV.read(Rails.root.join('data', 'judge_numerical_indicators.csv'), col_sep: "\t", headers: true).each do |line|
        judge = Judge.find_by_name(line[0])

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

        value = '' if value == 'N/A'
        value = '' if value =~ /\A(\d+\s-\s-+;?\s?)+\z/
        value = value.gsub(/-/, '–')
        value = value.split(',').map { |name| Court.find_by_name(normalize_court_name name) } if key.in?(%w(S3_2011 S3_2012 S3_2013))

        values[key] = value.presence
      end
    end

    def self.normalize_numerical_values(values)
      values.each_with_index do |(key, value), index|
        value = value.to_i if index.in? 2..9

        values[key] = value
      end
    end
  end
end
