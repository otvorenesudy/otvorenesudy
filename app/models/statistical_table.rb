class StatisticalTable < ActiveRecord::Base
  scope :by_name, lambda { |name| joins(:name).where('value = ?', name) }

  belongs_to :statistical_summary, foreign_key: :statistical_summary_id, polymorphic: true

  alias :summary  :statistical_summary
  alias :summary= :statistical_summary=

  belongs_to :name, class_name: :StatisticalTableName,
                    foreign_key: :statistical_table_name_id

  has_many :columns, class_name: :StatisticalTableColumn, dependent: :destroy
  has_many :rows,    class_name: :StatisticalTableRow,    dependent: :destroy
end
