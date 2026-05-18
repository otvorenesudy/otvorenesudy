class LegislationArea < ApplicationRecord

  has_many :decrees

  validates :value, presence: true
end
