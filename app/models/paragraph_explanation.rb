class ParagraphExplanation < ApplicationRecord
  belongs_to :paragraph
  belongs_to :explainable, polymorphic: true
end
