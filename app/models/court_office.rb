class CourtOffice < ActiveRecord::Base
  attr_accessible :email,
                  :phone,
                  :hours_monday,
                  :hours_tuesday,
                  :hours_wednesday,
                  :hours_thursday,
                  :hours_friday,
                  :note

  belongs_to :court

  belongs_to :type, class_name: :CourtOfficeType, foreign_key: :court_office_type_id
end
