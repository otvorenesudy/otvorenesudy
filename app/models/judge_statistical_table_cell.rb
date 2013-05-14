class JudgeStatisticalTableCell < ActiveRecord::Base
  attr_accessible :value

  belongs_to :column, class_name: :JudgeStatisticalTableColumn,
                      foreign_key: :judge_statistical_table_column_id
  
  belongs_to :row, class_name: :JudgeStatisticalTableRow,
                   foreign_key: :judge_statistical_table_row_id
  
  validates :value, presence: true
end
