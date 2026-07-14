class CourtJurisdiction < ApplicationRecord
  belongs_to :proceeding_type, class_name: :CourtProceedingType,
                               foreign_key: :court_proceeding_type_id

  belongs_to :municipality

  has_many :courts
end
