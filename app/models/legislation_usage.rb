class LegislationUsage < ActiveRecord::Base
  belongs_to :legislation
  belongs_to :decree
end
