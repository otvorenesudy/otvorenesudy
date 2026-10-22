# frozen_string_literal: true

class CourtOffice < ApplicationRecord
  belongs_to :court, optional: true

  belongs_to :type, class_name: 'CourtOfficeType',
                    foreign_key: :court_office_type_id,
                    inverse_of: false,
                    optional: true
end
