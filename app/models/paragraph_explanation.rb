class ParagraphExplanation < ActiveRecord::Base
  belongs_to :paragraph
  belongs_to :explainable, polymorphic: true
end
