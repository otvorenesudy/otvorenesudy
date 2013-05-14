class JudgeStatisticalTableName < ActiveRecord::Base
  attr_accessible :value
  
  has_many :tables, class_name: :JudgeStatisticalTable
             
  validates :value, presence: true
end
