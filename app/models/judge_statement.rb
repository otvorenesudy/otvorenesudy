class JudgeStatement < ApplicationRecord

  has_many :proclaims, class_name: :JudgeProclaim,
                       foreign_key: :judge_proclaim_id

  validates :value, presence: true
end
