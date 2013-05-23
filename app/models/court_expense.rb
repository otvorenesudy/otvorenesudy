class CourtExpense < ActiveRecord::Base
  include Resource::Uri

  attr_accessible :year, :value

  belongs_to :court

  validates :value, presence: true
  validates :year,  presence: true
end
