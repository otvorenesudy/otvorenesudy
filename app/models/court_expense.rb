class CourtExpense < ApplicationRecord
  include Resource::URI


  belongs_to :court

  validates :value, presence: true
  validates :year,  presence: true
end
