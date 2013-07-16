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

  scope :by_court_type, lambda { |type| joins(:court).where(:'courts.court_type_id' => type.id) }
  scope :by_year, lambda { order(:year) }


  belongs_to :court
  delegate :type, to: :court, prefix: true # TODO: creates delegation to court.type by court_type

  belongs_to :judge

  has_many :tables, class_name: :StatisticalTable, as: :statistical_summary

  belongs_to :senate_inclusion, class_name: :JudgeSenateInclusion,
                                foreign_key: :judge_senate_inclusion_id

  # TODO: validate presence of date and author
  validates :year,   presence: true

  scope :by_prominent_court_type, lambda {
    types = joins(:court).group('courts.court_type_id').order(:count_all).count

    return unless types.any?

    if types.values.uniq.size == 1
      summaries = where(year: self.order(:year).last.year)
      max       = summaries.map(&:assign_issues_count).max

      type = summaries.find { |s| s.assign_issues_count == max }.court_type
    else
      type = CourtType.find(types.keys.last)
    end

    by_court_type(type)
  }

  def assign_issues_count
    tables.by_name('P').map { |table| table.rows[0].cells.pluck(:value).map(&:to_i).sum }.sum
  end
end
