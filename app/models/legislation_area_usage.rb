# frozen_string_literal: true

class LegislationAreaUsage < ApplicationRecord
  belongs_to :decree, dependent: :destroy
  belongs_to :legislation_area, dependent: :destroy
end
