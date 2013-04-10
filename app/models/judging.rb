class Judging < ActiveRecord::Base
  attr_accessible :judge_name_similarity,
                  :judge_name_unprocessed,
                  :judge_chair

  scope :exact,   where('judgings.judge_name_similarity = 1.0')
  scope :inexact, where('judgings.judge_name_similarity < 1.0')

  scope :normal,  where('judgings.judge_chair = false')
  scope :chaired, where('judgings.judge_chair = true')

  scope :of_judge, lambda { |judge| where judge_id: judge }

  belongs_to :judge
  belongs_to :hearing
end
