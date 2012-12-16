class CourtType < ActiveRecord::Base
  attr_accessible :value
  
  has_many :courts, dependent: :destroy
  
  validates :value, presence: true
end
