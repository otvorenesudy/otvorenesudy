# frozen_string_literal: true

class JudgeStatisticalSummary < ApplicationRecord
  include Resource::URI

  scope :by_prominent_court_type, lambda { |judge|
    types = where(judge_id: judge.id).joins(:court).group('courts.court_type_id').order(:count_all).count

    return unless types.any?

    if types.values.uniq.size == 1
      summaries = where(year: where(judge_id: judge.id).order(:year).last.year, judge_id: judge.id)
      max       = summaries.map(&:assigned_issues_count).max

      type = summaries.find { |s| s.assigned_issues_count == max }.court_type
    else
      type = CourtType.find(types.keys.last)
    end

    by_court_type(type)
  }

  scope :by_court_type, ->(type) { joins(:court).where(courts: { court_type_id: type.id }) }

  scope :by_year, -> { order(:year) }

  belongs_to :court, optional: true

  delegate :type, to: :court, prefix: true

  belongs_to :judge, optional: true

  has_many :tables, class_name: 'StatisticalTable', as: :statistical_summary, dependent: nil

  belongs_to :senate_inclusion, class_name: 'JudgeSenateInclusion',
                                foreign_key: :judge_senate_inclusion_id,
                                inverse_of: false,
                                optional: true

  # TODO: validate presence of date and author, currently missing in preprocessed files
  validates :year, presence: true

  def assigned_issues_count
    tables.by_name('P').sum { |table| table.rows[0].cells.pluck(:value).sum(&:to_i) }
  end
end
