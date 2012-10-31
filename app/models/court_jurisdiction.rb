class CourtJurisdiction < ActiveRecord::Base
  belongs_to :proceeding_type, class_name: :CourtProceedingType
  
  belongs_to :municipality
  
  has_many :courts
end
