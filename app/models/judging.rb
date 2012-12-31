class Judging < ActiveRecord::Base
  attr_accessible :judge_name_similarity,
                  :judge_name_unprocessed,
                  :judge_chair
  
  belongs_to :judge
  belongs_to :hearing
end
