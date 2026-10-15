# frozen_string_literal: true

class JudgeStatement < ApplicationRecord
  has_many :proclaims, class_name: 'JudgeProclaim',
                       foreign_key: :judge_proclaim_id,
                       inverse_of: false,
                       dependent: nil

  validates :value, presence: true
end
