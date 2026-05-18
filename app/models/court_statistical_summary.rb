class CourtStatisticalSummary < ApplicationRecord
  include Resource::URI


  belongs_to :court

  has_many :tables, class_name: :StatisticalTable, as: :statistical_summary

  validates :year, presence: true
end
