class Accusation < ActiveRecord::Base
  attr_accessible :value,
                  :value_unprocessed

  belongs_to :defendant

  has_many :paragraph_explanations, dependent: :destroy, as: :explainable

  has_many :paragraphs, through: :paragraph_explanations

  validates :value, presence: true
end
