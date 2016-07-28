class CourtOfficeType < ActiveRecord::Base
  include Resource::Enumerable

  attr_accessible :value

  has_many :offices, class_name: :CourtOffice, dependent: :destroy

  validates :value, presence: true

  # TODO translate (needs database update)

  value :information_center,       'Informačné centrum'
  value :registry_center,          'Podateľňa'
  value :business_registry_center, 'Informačné stredisko obchodného registra'
end
