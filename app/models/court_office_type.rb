class CourtOfficeType < ApplicationRecord
  include Resource::Enumerable


  has_many :offices, class_name: :CourtOffice, dependent: :destroy

  validates :value, presence: true

  value :information_center,       'Informačné centrum'
  value :registry_center,          'Podateľňa'
  value :business_registry_center, 'Informačné stredisko obchodného registra'
end
