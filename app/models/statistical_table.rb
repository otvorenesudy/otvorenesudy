# frozen_string_literal: true

class StatisticalTable < ApplicationRecord
  scope :by_name, ->(name) { joins(:name).where(statistical_table_names: { value: name }) }

  belongs_to :statistical_summary, polymorphic: true, optional: true

  alias summary statistical_summary
  alias summary= statistical_summary=

  belongs_to :name, class_name: 'StatisticalTableName',
                    foreign_key: :statistical_table_name_id,
                    inverse_of: false,
                    optional: true

  has_many :columns, class_name: 'StatisticalTableColumn', dependent: :destroy
  has_many :rows,    class_name: 'StatisticalTableRow',    dependent: :destroy
end
