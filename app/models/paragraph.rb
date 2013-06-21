class Paragraph < ActiveRecord::Base
  attr_accessible :legislation,
                  :number,
                  :description

  has_many :explainations, class_name: :ParagraphExplaination

  validates :legislation, presence: true
  validates :number,      presence: true
  validates :description, presence: true
end
