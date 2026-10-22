# frozen_string_literal: true

class JudgeSenateInclusion < ApplicationRecord
  has_many :summaries, class_name: 'JudgeStatisticalSummary', dependent: nil

  validates :value, presence: true
end
