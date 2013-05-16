class DecreePage < ActiveRecord::Base
  attr_accessible :number,
                  :text
  
  belongs_to :decree
             
  validates :number, presence: true
  validates :text,   presence: true
end
