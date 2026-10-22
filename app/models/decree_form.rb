# frozen_string_literal: true

class DecreeForm < ApplicationRecord
  has_many :decrees, dependent: nil

  validates :value, presence: true
  validates :code,  presence: true
end
