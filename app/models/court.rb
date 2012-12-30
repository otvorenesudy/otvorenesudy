# encoding: utf-8

class Court < ActiveRecord::Base
  #include Resource::Storage.use(JusticeGovSk::Storages::CourtPageStorage) # TODO rm or refactor
  extend Resource::Similarity

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
    
  # TODO rm
  #include PgSearch
  #pg_search_scope :search_by_name, against: name, using: :trigram
  
  scope :by_type, lambda { |value| joins(:type).where('value = ?', value) }
 
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

  def address(format = '%s, %z %m')
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

end
