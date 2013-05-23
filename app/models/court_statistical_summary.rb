class CourtStatisticalSummary < ActiveRecord::Base
  belongs_to :source
  belongs_to :court
  attr_accessible :uri, :year

  has_many :tables, class_name: :StatisticalTable, as: :statistical_summary

  validates :uri,  presence: true
  validates :year, presence: true
end
