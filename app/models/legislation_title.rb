class LegislationTitle < ActiveRecord::Base
  attr_accessible :paragraph, :value

  has_many :legislations

  validates :paragraph, presence: true
  validates :value,     presence: true
end
