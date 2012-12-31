class CourtOfficeType < ActiveRecord::Base
  attr_accessible :value
  
  has_many :offices, class_name: :CourtOffice, dependent: :destroy
  
  validates :value, presence: true
end
