class LegislationAreaUsage < ActiveRecord::Base
  belongs_to :decree, dependent: :destroy
  belongs_to :legislation_area, dependent: :destroy

  validates :decree, presence: true
  validates :legislation_area, presence: true
end
