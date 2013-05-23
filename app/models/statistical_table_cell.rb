class StatisticalTableCell < ActiveRecord::Base
  attr_accessible :value

  belongs_to :column, class_name: :StatisticalTableColumn,
                      foreign_key: :statistical_table_column_id

  belongs_to :row, class_name: :StatisticalTableRow,
                   foreign_key: :statistical_table_row_id

  validates :value, presence: true
end
