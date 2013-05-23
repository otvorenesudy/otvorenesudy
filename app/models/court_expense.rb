class CourtExpense < ActiveRecord::Base
  belongs_to :source
  belongs_to :court
  attr_accessible :uri, :value, :year

  validates :uri,   presence: true
  validates :value, presence: true
  validates :year,  presence: true
end
