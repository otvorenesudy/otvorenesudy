class Judgement < ActiveRecord::Base
  attr_accessible :judge_name_similarity,
                  :judge_name_unprocessed
  
  belongs_to :judge
  belongs_to :decree
end
