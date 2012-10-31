class Court < ActiveRecord::Base
  attr_accessible :name,
                  :street,
                  :email,
                  :phone,
                  :fax,
                  :media_person_name,
                  :media_phone,
                  :latitude,
                  :longitude
  
  belongs_to :type, class_name: :CourtType
  
  has_many :employments, dependent: :destroy
  
  has_many :judges, through: :employments
  
  has_many :hearings, dependent: :destroy
  has_many :decrees,  dependent: :destroy
  
  belongs_to :jurisdiction, class_name: :CourtJurisdiction
  
  belongs_to :information_center, class_name: :CourtOffice,
                                  dependent: :destroy
  
  belongs_to :registry_center, class_name: :CourtOffice,
                               dependent: :destroy
  
  belongs_to :business_registry_center, class_name: :CourtOffice,
                                        dependent: :destroy
             
  validates :name,   presence: true
  validates :street, presence: true
end
