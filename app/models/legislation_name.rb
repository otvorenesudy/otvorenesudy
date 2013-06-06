class LegislationName < ActiveRecord::Base
  attr_accessible :value,
                  :paragraph

  # TODO update DIA
  # TODO do something with the paragraph attr, it is confusing due to the existence of legistation.paragraph

  has_many :legislations

  validates :value,     presence: true
  validates :paragraph, presence: true
end
