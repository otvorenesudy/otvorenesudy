# frozen_string_literal: true

class LegislationArea < ApplicationRecord
  has_many :decrees, dependent: nil

  validates :value, presence: true
end
