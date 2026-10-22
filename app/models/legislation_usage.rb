# frozen_string_literal: true

class LegislationUsage < ApplicationRecord
  belongs_to :legislation, optional: true
  belongs_to :decree, optional: true
end
