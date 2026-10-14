# frozen_string_literal: true

class StatisticalTableName < ApplicationRecord
  has_many :tables, class_name: 'StatisticalTable', dependent: nil

  validates :value, presence: true
end
