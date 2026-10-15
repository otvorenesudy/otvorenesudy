# frozen_string_literal: true

class Judging < ApplicationRecord
  include Judge::Matched

  scope :normal,  -> { where(judge_chair: false) }
  scope :chaired, -> { where(judge_chair: true) }

  scope :of_judge, ->(judge) { where(judge_id: judge) }

  belongs_to :judge, optional: true
  belongs_to :hearing, optional: true
end
