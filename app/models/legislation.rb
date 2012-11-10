class Legislation < ActiveRecord::Base
  attr_accessible :value,
                  :value_unprocessed,
                  :number,
                  :year,
                  :name,
                  :paragraph,
                  :section,
                  :letter,
                  :original
  
  has_many :usages, class_name: :LegislationUsage,
                    foreign_key: :legislation_usage_id
  
  has_many :decrees, through: :usages
  
  validates :value,     presence: true
  validates :number,    presence: true
  validates :year,      presence: true
  validates :name,      presence: true
  validates :paragraph, presence: true
  validates :section,   presence: true
  validates :original,  presence: true
end
