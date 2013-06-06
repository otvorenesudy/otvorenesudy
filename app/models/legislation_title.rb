class LegislationTitle < ActiveRecord::Base
  attr_accessible :letter, :paragraph, :section, :value

  has_many :legislations

  validates :paragraph, presence: true
  validates :value,     presence: true
end
