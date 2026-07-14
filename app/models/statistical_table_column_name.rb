class StatisticalTableColumnName < ApplicationRecord

  has_many :columns, class_name: :StatisticalTableColumn

  validates :value, presence: true
end
