class Municipality < ApplicationRecord

  has_many :courts, dependent: :destroy

  has_many :court_jurisdictions, dependent: :destroy

  validates :name,    presence: true
  validates :zipcode, presence: true
end
