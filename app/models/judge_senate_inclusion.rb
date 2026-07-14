class JudgeSenateInclusion < ApplicationRecord

  has_many :summaries, class_name: :JudgeStatisticalSummary

  validates :value, presence: true
end
