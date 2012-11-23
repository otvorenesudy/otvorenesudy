class Judging < ActiveRecord::Base
  attr_accessible :judge_matched_exactly,
                  :judge_name_unprocessed
  
  belongs_to :judge
  belongs_to :hearing
end
