class Accusation < ActiveRecord::Base
  attr_accessible :value
  
  belongs_to :defendant
             
  validates :value, presence: true
end
