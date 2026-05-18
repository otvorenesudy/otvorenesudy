class LegislationUsage < ApplicationRecord
  belongs_to :legislation
  belongs_to :decree
end
