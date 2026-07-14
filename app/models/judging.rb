class Judging < ApplicationRecord

  include Judge::Matched

  scope :normal,  -> { where('judge_chair = false') }
  scope :chaired, -> { where('judge_chair = true') }

  scope :of_judge, lambda { |judge| where judge_id: judge }

  belongs_to :judge
  belongs_to :hearing
end
