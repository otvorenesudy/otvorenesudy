class JudgeStatisticalTableRow < ActiveRecord::Base
  belongs_to :table, class_name: :JudgeStatisticalTable,
                     foreign_key: :judge_statistical_table_id

  belongs_to :name, class_name: :JudgeStatisticalTableRowName,
                    foreign_key: :judge_statistical_table_row_name_id

  has_many :cells, class_name: :JudgeStatisticalTableCell
end
