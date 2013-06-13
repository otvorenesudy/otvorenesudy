class Legislation < ActiveRecord::Base
  attr_accessible :value,
                  :value_unprocessed,
                  :type,
                  :number,
                  :year,
                  :name,
                  :paragraph,
                  :section,
                  :letter

  has_many :usages, class_name: :LegislationUsage

  has_many :decrees, through: :usages

  has_many :paragraph_explainations, dependent: :destroy, as: :explainable
  
  has_many :paragraphs, through: :explainations
end
