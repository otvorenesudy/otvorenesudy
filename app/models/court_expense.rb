# frozen_string_literal: true

class CourtExpense < ApplicationRecord
  include Resource::URI

  belongs_to :court, optional: true

  validates :value, presence: true
  validates :year,  presence: true
end
