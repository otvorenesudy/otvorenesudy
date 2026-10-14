# frozen_string_literal: true

class Paragraph < ApplicationRecord
  has_many :explanations, class_name: 'ParagraphExplanation', dependent: nil

  validates :legislation, presence: true
  validates :number,      presence: true
  validates :description, presence: true
end
