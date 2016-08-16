class CourtType < ActiveRecord::Base
  include Resource::Enumerable

  attr_accessible :value

  has_many :courts, dependent: :destroy

  validates :value, presence: true

  value :constitutional, 'Ústavný'
  value :supreme,        'Najvyšší'
  value :specialized,    'Špecializovaný'
  value :regional,       'Krajský'
  value :district,       'Okresný'
end
