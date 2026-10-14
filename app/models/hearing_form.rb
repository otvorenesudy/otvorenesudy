# frozen_string_literal: true

class HearingForm < ApplicationRecord
  has_many :hearings, dependent: nil

  validates :value, presence: true
end
