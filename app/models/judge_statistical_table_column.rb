class JudgeStatisticalTableColumn < ActiveRecord::Base
  belongs_to :table, class_name: :JudgeStatisticalTable,
                     foreign_key: :judge_statistical_table_id

  belongs_to :name, class_name: :JudgeStatisticalTableColumnName,
                    foreign_key: :judge_statistical_table_column_name_id

  has_many :cells, class_name: :JudgeStatisticalTableCell
end
