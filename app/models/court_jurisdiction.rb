# frozen_string_literal: true

class CourtJurisdiction < ApplicationRecord
  belongs_to :proceeding_type, class_name: 'CourtProceedingType',
                               foreign_key: :court_proceeding_type_id,
                               inverse_of: false,
                               optional: true

  belongs_to :municipality, optional: true

  has_many :courts, dependent: nil
end
