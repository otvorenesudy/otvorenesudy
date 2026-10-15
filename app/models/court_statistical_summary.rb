# frozen_string_literal: true

class CourtStatisticalSummary < ApplicationRecord
  include Resource::URI

  belongs_to :court, optional: true

  has_many :tables, class_name: 'StatisticalTable', as: :statistical_summary, dependent: nil

  validates :year, presence: true
end
