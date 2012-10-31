class Municipality < ActiveRecord::Base
  attr_accessible :name
  
  has_many :courts, dependent: :destroy
  
  has_many :court_jurisdictions, dependent: :destroy
             
  validates :name, presence: true
end
