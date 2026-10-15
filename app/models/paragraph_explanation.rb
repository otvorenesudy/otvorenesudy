# frozen_string_literal: true

class ParagraphExplanation < ApplicationRecord
  belongs_to :paragraph, optional: true
  belongs_to :explainable, polymorphic: true, optional: true
end
