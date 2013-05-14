class JudgeStatisticalSummary < ActiveRecord::Base
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
  
  belongs_to :court
  
  belongs_to :judge
  
  has_many :tables, class_name: :JudgeStatisticalTable
  
  belongs_to :senate_inclusion, class_name: :JudgeSenateInclusion,
                                foreign_key: :judge_senate_inclusion_id

  validates :author, presence: true
  validates :year,   presence: true
  validates :date,   presence: true
end
