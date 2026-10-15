# frozen_string_literal: true

class Judge
  module SubstantiationNotes
    extend ActiveSupport::Concern

    def substantiation_notes_by_year
      @substantiation_notes_by_year ||= statistical_summaries.order(year: :desc).filter_map do |summary|
        [summary.year, summary.substantiation_notes] if summary.substantiation_notes.present?
      end
    end
  end
end
