class JudgeStatisticalTableColumnName < ActiveRecord::Base
  attr_accessible :value
  
  has_many :columns, class_name: :JudgeStatisticalTableColumn
             
  validates :value, presence: true
end
