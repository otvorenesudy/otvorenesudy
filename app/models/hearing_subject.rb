class HearingSubject < ApplicationRecord

  has_many :hearings

  validates :value, presence: true
end
