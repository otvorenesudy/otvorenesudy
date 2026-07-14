class HearingType < ApplicationRecord
  include Resource::Enumerable


  has_many :hearings

  validates :value, presence: true

  value :civil,    'Civilné'
  value :criminal, 'Trestné'
  value :special,  'Špecializovaného trestného súdu'
end
