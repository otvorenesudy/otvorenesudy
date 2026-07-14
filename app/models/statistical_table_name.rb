class StatisticalTableName < ApplicationRecord

  has_many :tables, class_name: :StatisticalTable

  validates :value, presence: true
end
