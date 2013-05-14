class JudgeStatisticalTableRowName < ActiveRecord::Base
  attr_accessible :value
  
  has_many :rows, class_name: :JudgeStatisticalTableRow
             
  validates :value, presence: true
end
