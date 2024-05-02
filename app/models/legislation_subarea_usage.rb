class LegislationSubareaUsage < ActiveRecord::Base
  belongs_to :decree, dependent: :destroy
  belongs_to :legislation_subarea, dependent: :destroy

  validates :decree, presence: true
  validates :legislation_subarea, presence: true
end
