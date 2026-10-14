# frozen_string_literal: true

class Judgement < ApplicationRecord
  include Judge::Matched

  scope :of_judge, ->(judge) { where(judge_id: judge) }

  belongs_to :judge, optional: true
  belongs_to :decree, optional: true
end
