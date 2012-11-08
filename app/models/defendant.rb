class Defendant < ActiveRecord::Base
  attr_accessible :name
  
  belongs_to :hearing

  has_many :accusations, dependent: :destroy
             
  validates :name, presence: true
end
