class StatisticalTableColumn < ActiveRecord::Base
  scope :by_name, lambda { |name| joins(:name).where('value = ?', name) }

  belongs_to :table, class_name: :StatisticalTable,
                     foreign_key: :statistical_table_id

  belongs_to :name, class_name: :StatisticalTableColumnName,
                    foreign_key: :statistical_table_column_name_id

  has_many :cells, class_name: :StatisticalTableCell, dependent: :destroy
end
