# frozen_string_literal: true

class JudgeDesignationType < ApplicationRecord
  has_many :designations, class_name: 'JudgeDesignation', dependent: nil

  validates :value, presence: true
end
