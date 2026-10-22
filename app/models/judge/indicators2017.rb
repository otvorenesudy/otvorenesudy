# frozen_string_literal: true

class Judge
  module Indicators2017
    extend ActiveSupport::Concern

    # The assigned cases per agenda.
    AGENDAS = {
      'Občianska' => 'C.assigned.agenda',
      'Obchodná' => 'Cb.assigned.agenda',
      'Poručenská' => 'P.assigned.agenda',
      'Trestná' => 'Trest.assigned.agenda'
    }.freeze

    # The 2017 table names the decided agenda unlike the other years: the criminal one in full, none as NA.
    DECIDED_AGENDAS = { 'trestná' => 'Trest', 'NA' => '0' }.freeze

    DATASET = Judge::Indicators::Dataset.new(
      files: { statistical: 'judge-statistical-indicators-2017.csv', numerical: 'judge-numerical-indicators-2017.csv' },
      separator: ',',
      judge: :id,
      numerical_columns: 3..9,
      chart_columns: 3..6
    ) do |key, value, courts|
      value = value.gsub('-', ' – ') if key == 'rank'
      value = DECIDED_AGENDAS.fetch(value, value) if key == 'decided.agenda.dominant'
      value = Judge::Indicators.court(value, courts) if key == 'court'

      value.presence
    end

    included do
      mapping do
        analyze :indicators_2017, as: ->(judge) { DATASET.complete?(judge) }
        analyze :decree_agenda_2017, as: ->(judge) { DATASET.dominant_agenda(judge, AGENDAS) }
      end

      facets do
        facet :indicators_2017, type: :terms, visible: false
        facet :decree_agenda_2017, type: :terms, visible: false
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

    def indicators_2017
      Judge::Indicators2017.for(self)
    end
  end
end
