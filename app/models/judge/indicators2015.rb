# frozen_string_literal: true

class Judge
  module Indicators2015
    extend ActiveSupport::Concern

    # The assigned cases per agenda.
    AGENDAS = {
      'Občianska' => 'C.assigned.agenda',
      'Obchodná' => 'Cb.assigned.agenda',
      'Poručenská' => 'P.assigned.agenda',
      'Trestná' => 'Trest.assigned.agenda'
    }.freeze

    DATASET = Judge::Indicators::Dataset.new(
      files: { statistical: 'judge-statistical-indicators-2015.csv', numerical: 'judge-numerical-indicators-2015.csv' },
      separator: ',',
      judge: :id,
      numerical_columns: 3..9,
      chart_columns: 3..6
    ) do |key, value, courts|
      value = value.gsub('-', ' – ') if key == 'rank'
      value = Judge::Indicators.court(value, courts) if key == 'court'

      value.presence
    end

    included do
      mapping do
        analyze :indicators_2015, as: ->(judge) { DATASET.complete?(judge) }
        analyze :decree_agenda_2015, as: ->(judge) { DATASET.dominant_agenda(judge, AGENDAS) }
      end

      facets do
        facet :indicators_2015, type: :terms, visible: false
        facet :decree_agenda_2015, type: :terms, visible: false
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

    def indicators_2015
      Judge::Indicators2015.for(self)
    end
  end
end
