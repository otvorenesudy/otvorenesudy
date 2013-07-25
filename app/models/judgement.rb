class Judgement < ActiveRecord::Base
  include Judge::Matched

  attr_accessible :judge_name_similarity,
                  :judge_name_unprocessed

  scope :of_judge, lambda { |judge| where judge_id: judge }

  belongs_to :judge
  belongs_to :decree
end
