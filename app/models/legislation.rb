class Legislation < ActiveRecord::Base
  attr_accessible :number,
                  :year,
                  :name,
                  :paragraph,
                  :section,
                  :letter
  
  has_many :usages, class_name: :LegislationUsage,
                    foreign_key: :legislation_usage_id
  
  has_many :decrees, through: :usages
  
  validates :number,    presence: true
  validates :year,      presence: true
  validates :name,      presence: true
  validates :paragraph, presence: true
  validates :section,   presence: true
end
