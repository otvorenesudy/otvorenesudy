class Accusation < ActiveRecord::Base
  attr_accessible :value,
                  :value_unprocessed
  
  belongs_to :defendant
  
  has_many :paragraph_explainations, dependent: :destroy, as: :explainable
  
  has_many :paragraphs, through: :explainations
             
  validates :value, presence: true
end
