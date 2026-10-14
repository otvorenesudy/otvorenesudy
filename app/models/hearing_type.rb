# frozen_string_literal: true

class HearingType < ApplicationRecord
  include Resource::Enumerable

  has_many :hearings, dependent: nil, inverse_of: :type

  validates :value, presence: true

  value :civil, 'Civilné'
  value :criminal, 'Trestné'
  value :special, 'Špecializovaného trestného súdu'
end
