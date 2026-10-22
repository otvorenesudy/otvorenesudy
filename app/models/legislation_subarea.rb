# frozen_string_literal: true

class LegislationSubarea < ApplicationRecord
  has_many :decrees, dependent: nil

  validates :value, presence: true
end
