# frozen_string_literal: true

class StatisticalTableColumnName < ApplicationRecord
  has_many :columns, class_name: 'StatisticalTableColumn', dependent: nil

  validates :value, presence: true
end
