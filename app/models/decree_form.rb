class DecreeForm < ActiveRecord::Base
  attr_accessible :value,
                  :code
  
  has_many :decrees
             
  validates :value, presence: true
  validates :code,  presence: true
end
