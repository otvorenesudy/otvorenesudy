class JudgeStatisticalSummary < ActiveRecord::Base
  include Resource::URI

  attr_accessible :author,
                  :year,
                  :date,
                  :days_worked,
                  :days_heard,
                  :days_used,
                  :released_constitutional_decrees,
                  :delayed_constitutional_decrees,
                  :idea_reduction_reasons,
                  :educational_activities,
                  :substantiation_notes,
                  :court_chair_actions

  scope :by_prominent_court_type, lambda { |judge|
    types = where(judge_id: judge.id).joins(:court).group('courts.court_type_id').order(:count_all).count

    return unless types.any?

    if types.values.uniq.size == 1
      summaries = where(year: self.where(judge_id: judge.id).order(:year).last.year, judge_id: judge.id)
      max       = summaries.map(&:assigned_issues_count).max

      type = summaries.find { |s| s.assigned_issues_count == max }.court_type
    else
      type = CourtType.find(types.keys.last)
    end

    by_court_type(type)
  }

  scope :by_court_type, lambda { |type| joins(:court).where(:'courts.court_type_id' => type.id) }

  scope :by_year, lambda { order(:year) }

  belongs_to :court

  delegate :type, to: :court, prefix: true

  belongs_to :judge

  has_many :tables, class_name: :StatisticalTable, as: :statistical_summary

  belongs_to :senate_inclusion, class_name: :JudgeSenateInclusion,
                                foreign_key: :judge_senate_inclusion_id

  # TODO: validate presence of date and author, currently missing in preprocessed files
  validates :year, presence: true

  def assigned_issues_count
    tables.by_name('P').map { |table| table.rows[0].cells.pluck(:value).map(&:to_i).sum }.sum
  end
end
