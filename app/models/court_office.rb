class CourtOffice < ApplicationRecord

  belongs_to :court

  belongs_to :type, class_name: :CourtOfficeType, foreign_key: :court_office_type_id
end
