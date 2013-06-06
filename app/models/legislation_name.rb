class LegislationName < ActiveRecord::Base
  attr_accessible :value, :paragraph

  has_many :legislations

  validates :value,     presence: true
  validates :paragraph, presence: true
end
