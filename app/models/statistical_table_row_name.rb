class StatisticalTableRowName < ApplicationRecord

  has_many :rows, class_name: :StatisticalTableRow

  validates :value, presence: true
end
