class Paragraph < ActiveRecord::Base
  attr_accessible :legislation,
                  :number,
                  :description

  has_many :explanations, class_name: :ParagraphExplanation

  validates :legislation, presence: true
  validates :number,      presence: true
  validates :description, presence: true
end
