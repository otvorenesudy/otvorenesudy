# frozen_string_literal: true

class Accusation < ApplicationRecord
  belongs_to :defendant, optional: true

  has_many :paragraph_explanations, dependent: :destroy, as: :explainable

  has_many :paragraphs, through: :paragraph_explanations

  validates :value, presence: true
end
