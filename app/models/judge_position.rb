class JudgePosition < ActiveRecord::Base
  attr_accessible :value
  
  has_many :employments, dependent: :destroy
  
  has_many :judges, through: :employments
             
  validates :value, presence: true
end
