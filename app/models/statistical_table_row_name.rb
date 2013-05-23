class StatisticalTableRowName < ActiveRecord::Base
  attr_accessible :value

  has_many :rows, class_name: :StatisticalTableRow

  validates :value, presence: true
end
