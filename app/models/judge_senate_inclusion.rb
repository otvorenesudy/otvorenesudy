class JudgeSenateInclusion < ActiveRecord::Base
  attr_accessible :value

  has_many :summaries, class_name: :JudgeStatisticalSummary

  validates :value, presence: true
end
