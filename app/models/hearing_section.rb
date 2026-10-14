# frozen_string_literal: true

class HearingSection < ApplicationRecord
  has_many :hearings, dependent: nil

  validates :value, presence: true
end
