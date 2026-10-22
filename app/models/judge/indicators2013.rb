# frozen_string_literal: true

class Judge
  module Indicators2013
    extend ActiveSupport::Concern

    COURT_COLUMNS = %w[S3_2011 S3_2012 S3_2013].freeze

    # The decided cases per agenda.
    AGENDAS = { 'Občianska' => 'S5a', 'Obchodná' => 'S5b', 'Poručenská' => 'S5c', 'Trestná' => 'S5d' }.freeze

    DATASET = Judge::Indicators::Dataset.new(
      files: { statistical: 'judge_statistical_indicators.csv', numerical: 'judge_numerical_indicators.csv' },
      separator: "\t",
      judge: :name,
      numerical_columns: 2..9,
      chart_columns: 2..9
    ) do |key, value, courts|
      value = '' if value == 'N/A' || value.match?(/\A(\d+\s-\s-+;?\s?)+\z/)
      value = value.tr('-', '–')
      value = value.split(',').map { |name| Judge::Indicators.court(name, courts) } if COURT_COLUMNS.include?(key)

      value.presence
    end

    included do
      mapping do
        analyze :indicators_2013, as: ->(judge) { DATASET.complete?(judge) }
        analyze :decree_agenda_2013, as: ->(judge) { DATASET.dominant_agenda(judge, AGENDAS) }
      end

      facets do
        facet :indicators_2013, type: :terms, visible: false
        facet :decree_agenda_2013, type: :terms, visible: false
      end
    end

    def self.for(judge)
      DATASET.for(judge)
    end

    def self.numerical_values_for(judge)
      DATASET.numerical_values_for(judge)
    end

    def self.numerical_average
      DATASET.numerical_average
    end

    def indicators_2013
      Judge::Indicators2013.for(self)
    end
  end
end
