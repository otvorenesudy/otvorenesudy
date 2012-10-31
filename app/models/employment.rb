class Employment < ActiveRecord::Base
  belongs_to :court
  belongs_to :judge
  
  belongs_to :position, class_name: :JudgePosition
end
