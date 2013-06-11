class Accusation < ActiveRecord::Base
  attr_accessible :value,
                  :value_unprocessed
  
  belongs_to :defendant
             
  validates :value, presence: true
end
