# frozen_string_literal: true

class StatisticalTableRowName < ApplicationRecord
  has_many :rows, class_name: 'StatisticalTableRow', dependent: nil

  validates :value, presence: true
end
