class StatisticalTableName < ActiveRecord::Base
  attr_accessible :value

  has_many :tables, class_name: :StatisticalTable

  validates :value, presence: true
end
