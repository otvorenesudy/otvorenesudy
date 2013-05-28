class JudgePropertyDeclaration < ActiveRecord::Base
  include Resource::URI
  
  attr_accessible :year
  
  scope :of_year, lambda { |year| where('year = ?', year) }
  
  belongs_to :court
  
  belongs_to :judge
  
  has_many :lists, class_name: :JudgePropertyList,
                   dependent: :destroy
  
  has_many :incomes, class_name: :JudgeIncome,
                     dependent: :destroy

  has_many :proclaims, class_name: :JudgeProclaim,
                       dependent: :destroy
  
  has_many :statements, class_name: :JudgeStatement,
                        through: :proclaims

  has_many :related_persons, class_name: :JudgeRelatedPerson,
                             dependent: :destroy
  
  validates :year, presence: true
end
