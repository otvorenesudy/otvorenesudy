class StatisticalTable < ActiveRecord::Base
  belongs_to :summary, foreign_key: :statistical_summary_id, polymorphic: true

  belongs_to :name, class_name: :StatisticalTableName,
                    foreign_key: :statistical_table_name_id

  has_many :columns, class_name: :StatisticalTableColumn, dependent: :destroy
  has_many :rows,    class_name: :StatisticalTableRow,    dependent: :destroy
end
