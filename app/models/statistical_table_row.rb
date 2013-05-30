class StatisticalTableRow < ActiveRecord::Base
  belongs_to :table, class_name: :StatisticalTable,
                     foreign_key: :statistical_table_id

  belongs_to :name, class_name: :StatisticalTableRowName,
                    foreign_key: :statistical_table_row_name_id

  has_many :cells, class_name: :StatisticalTableCell, dependent: :destroy
end
