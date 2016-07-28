class HearingType < ActiveRecord::Base
  include Resource::Enumerable

  attr_accessible :value

  has_many :hearings

  validates :value, presence: true

  # TODO translate (needs database update)

  value :civil,    'Civilné'
  value :criminal, 'Trestné'
  value :special,  'Špecializovaného trestného súdu'
end
