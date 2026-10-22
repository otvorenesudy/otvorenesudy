# frozen_string_literal: true

class CourtType < ApplicationRecord
  include Resource::Enumerable

  has_many :courts, dependent: :destroy, inverse_of: :type

  validates :value, presence: true

  value :constitutional, 'Ústavný'
  value :supreme, 'Najvyšší'
  value :administrative, 'Správny'
  value :specialized, 'Špecializovaný'
  value :regional, 'Krajský'
  value :district, 'Okresný'
  value :municipal, 'Mestský'
end
