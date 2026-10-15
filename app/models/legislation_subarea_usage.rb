# frozen_string_literal: true

class LegislationSubareaUsage < ApplicationRecord
  belongs_to :decree, dependent: :destroy
  belongs_to :legislation_subarea, dependent: :destroy
end
