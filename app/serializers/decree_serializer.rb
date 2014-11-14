class DecreeSerializer < ActiveModel::Serializer
  attributes :id, :case_number, :file_number, :ecli, :text, :date, :created_at, :updated_at

  has_one :court
  has_one :form
  has_one :legislation_area
  has_one :legislation_subarea

  has_many :natures
  has_many :judges
  has_many :legislations
  has_many :defendants
  has_many :opponents
  has_many :proposers
end
