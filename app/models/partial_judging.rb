class PartialJudging < ActiveRecord::Base
  attr_accessible :judge_name,
                  :judge_name_unprocessed,
                  :judge_chair
  
  scope :normal,  where('judgings.judge_chair = false')
  scope :chaired, where('judgings.judge_chair = true')
  
  scope :of_judge_by_name, lambda { |name| where judge_name: name }
  
  belongs_to :hearing
end
