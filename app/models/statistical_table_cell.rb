class StatisticalTableCell < ActiveRecord::Base
  attr_accessible :value

  belongs_to :column, class_name: :StatisticalTableColumn,
                      foreign_key: :statistical_table_column_id

  belongs_to :row, class_name: :StatisticalTableRow,
                   foreign_key: :statistical_table_row_id

  validates :value, presence: true

  def self.of(table, column, row)
    column = StatisticalTableColumn.where(statistical_table_id: table).by_name(column).first unless column.is_a? StatisticalTableColumn
    row    = StatisticalTableRow.where(statistical_table_id: table).by_name(row).first unless row.is_a? StatisticalTableRow

    where(statistical_table_column_id: column, statistical_table_row_id: row).first
  end
end
