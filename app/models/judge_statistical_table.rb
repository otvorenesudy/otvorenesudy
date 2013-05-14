class JudgeStatisticalTable < ActiveRecord::Base
  belongs_to :summary, class_name: :JudgeStatisticalSummary,
                       foreign_key: :judge_statistical_summary_id

  belongs_to :name, class_name: :JudgeStatisticalTableName,
                    foreign_key: :judge_statistical_table_name_id

  has_many :columns, class_name: :JudgeStatisticalTableColumn

  has_many :rows, class_name: :JudgeStatisticalTableRow
end
