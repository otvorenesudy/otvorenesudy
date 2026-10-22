# frozen_string_literal: true

class StatisticalTableRow < ApplicationRecord
  scope :by_name, ->(name) { joins(:name).where(statistical_table_row_names: { value: name }) }

  belongs_to :table, class_name: 'StatisticalTable',
                     foreign_key: :statistical_table_id,
                     inverse_of: false,
                     optional: true

  belongs_to :name, class_name: 'StatisticalTableRowName',
                    foreign_key: :statistical_table_row_name_id,
                    inverse_of: false,
                    optional: true

  has_many :cells, class_name: 'StatisticalTableCell', dependent: :destroy
end
