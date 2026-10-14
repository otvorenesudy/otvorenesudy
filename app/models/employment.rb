# frozen_string_literal: true

class Employment < ApplicationRecord
  include Judge::Activity

  scope :at_court,         ->(court) { where(court_id: court) }
  scope :at_court_by_type, ->(type) { joins(:court).merge(Court.by_type(type)) }

  belongs_to :court, optional: true
  belongs_to :judge, optional: true
  belongs_to :judge_position, optional: true
end
