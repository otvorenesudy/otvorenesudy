class DecreeNature < ActiveRecord::Base
  attr_accessible :value
  
  has_many :decrees
             
  validates :value, presence: true
end
