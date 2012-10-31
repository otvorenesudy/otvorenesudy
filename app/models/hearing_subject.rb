class HearingSubject < ActiveRecord::Base
  attr_accessible :value
  
  has_many :hearings
             
  validates :value, presence: true
end
