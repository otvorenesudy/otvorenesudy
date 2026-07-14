class CourtProceedingType < ApplicationRecord

  has_many :jurisdictions, class_name: :CourtJurisdiction,
                           dependent: :destroy

  has_many :courts, through: :jurisdictions

  validates :value, presence: true
end
