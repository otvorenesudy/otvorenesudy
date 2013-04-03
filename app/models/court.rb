# encoding: utf-8

class Court < ActiveRecord::Base
  include Resource::Storage

  attr_accessible :uri,
                  :name,
                  :street,
                  :phone,
                  :fax,
                  :media_person,
                  :media_person_unprocessed,
                  :media_phone,
                  :latitude,
                  :longitude
  
  scope :by_type, lambda { |court_type| where('court_type_id = ?', court_type.id) }
 
  belongs_to :type, class_name: :CourtType, foreign_key: :court_type_id
  
  has_many :employments, dependent: :destroy
  
  has_many :judges, through: :employments
  
  has_many :hearings, dependent: :destroy
  has_many :decrees,  dependent: :destroy
  
  belongs_to :jurisdiction, class_name: :CourtJurisdiction
  
  belongs_to :municipality
  
  belongs_to :information_center,       class_name: :CourtOffice, dependent: :destroy
  belongs_to :registry_center,          class_name: :CourtOffice, dependent: :destroy
  belongs_to :business_registry_center, class_name: :CourtOffice, dependent: :destroy
  
  validates :name,   presence: true
  validates :street, presence: true
  
  acts_as_gmappable lat: :latitude, lng: :longitude, process_geocoding: false

  def address(format = nil)
    format ||= '%s, %z %m'
    
    parts = {
      '%s' => street,
      '%z' => municipality.zipcode,
      '%m' => municipality.name,
      '%c' => 'Slovenská republika'
    }
    
    format.gsub(/\%[szmc]/, parts)
  end
  
  def coordinates
    @coordinates ||= { latitude: latitude, longitude: longitude }
  end
  
  def chair
    judges.active.chair.first
  end
  
  def vicechair
    judges.active.vicechair.first
  end
  
  storage :page, JusticeGovSk::Storage::CourtPage, extension: :html
end
