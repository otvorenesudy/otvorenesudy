class CourtStatisticalSummary < ActiveRecord::Base
  include Resource::Uri
 
  attr_accessible :year

  belongs_to :court

  has_many :tables, class_name: :StatisticalTable, as: :statistical_summary

  validates :year, presence: true
end
