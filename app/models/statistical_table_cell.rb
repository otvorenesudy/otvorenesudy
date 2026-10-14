# frozen_string_literal: true

class StatisticalTableCell < ApplicationRecord
  belongs_to :column, class_name: 'StatisticalTableColumn',
                      foreign_key: :statistical_table_column_id,
                      inverse_of: false,
                      optional: true

  belongs_to :row, class_name: 'StatisticalTableRow',
                   foreign_key: :statistical_table_row_id,
                   inverse_of: false,
                   optional: true

  validates :value, presence: true

  def self.of(table, column, row)
    unless column.is_a?(StatisticalTableColumn)
      column = StatisticalTableColumn.where(statistical_table_id: table).by_name(column).first
    end

    unless row.is_a?(StatisticalTableRow)
      row = StatisticalTableRow.where(statistical_table_id: table).by_name(row).first
    end

    where(statistical_table_column_id: column, statistical_table_row_id: row).first
  end
end
