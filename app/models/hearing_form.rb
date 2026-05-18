class HearingForm < ApplicationRecord

  has_many :hearings

  validates :value, presence: true
end
