class Judgement < ActiveRecord::Base
  attr_accessible :judge_name_similarity,
                  :judge_name_unprocessed

  scope :exact,   where('judgements.judge_name_similarity = 1.0')
  scope :inexact, where('judgements.judge_name_similarity < 1.0')

  scope :of_judge, lambda { |judge| where judge_id: judge }

  belongs_to :judge
  belongs_to :decree
end
