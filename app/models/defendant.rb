class Defendant < ActiveRecord::Base
  attr_accessible :name
  
  has_many :hearings

  has_many :accusations, dependent: :destroy
             
  validates :name, presence: true
end
