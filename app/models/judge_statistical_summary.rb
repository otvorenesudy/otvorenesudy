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

  scope :by_court_type, lambda { |type| joins(:court).where('courts.court_type_id = ?', type.id) }

  scope :by_year, lambda { order(:year) }

  belongs_to :court

  belongs_to :judge

  has_many :tables, class_name: :StatisticalTable, as: :statistical_summary

  belongs_to :senate_inclusion, class_name: :JudgeSenateInclusion,
                                foreign_key: :judge_senate_inclusion_id

  # TODO: validate presence of date and author
  validates :year,   presence: true
end
