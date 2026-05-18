class Judgement < ApplicationRecord

  include Judge::Matched

  scope :of_judge, lambda { |judge| where judge_id: judge }

  belongs_to :judge
  belongs_to :decree
end
