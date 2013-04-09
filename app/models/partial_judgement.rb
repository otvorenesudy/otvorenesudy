class PartialJudgement < ActiveRecord::Base
  attr_accessible :judge_name,
                  :judge_name_unprocessed
  
  scope :of_judge_by_name, lambda { |name| where judge_name: name }
  
  belongs_to :decree
end
