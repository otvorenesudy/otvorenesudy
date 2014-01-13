class HearingSection < ActiveRecord::Base
  attr_accessible :value

  has_many :hearings

  validates :value, presence: true
end
