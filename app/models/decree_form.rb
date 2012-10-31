class DecreeForm < ActiveRecord::Base
  attr_accessible :value
  
  has_many :decrees
             
  validates :value, presence: true
end
