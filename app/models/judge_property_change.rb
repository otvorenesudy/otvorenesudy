# frozen_string_literal: true

class JudgePropertyChange < ApplicationRecord
  has_many :properties, class_name: 'JudgeProperty',
                        foreign_key: :judge_property_id,
                        inverse_of: false,
                        dependent: nil

  validates :value, presence: true
end
