class StatisticalTableColumnName < ActiveRecord::Base
  attr_accessible :value

  has_many :columns, class_name: :StatisticalTableColumn

  validates :value, presence: true
end
