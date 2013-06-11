class Paragraph < ActiveRecord::Base
  attr_accessible :number,
                  :description

  has_many :explainations, class_name: :ParagraphExplaination

  validates :number,      presence: true
  validates :description, presence: true
end
