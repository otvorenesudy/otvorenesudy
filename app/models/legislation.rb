class Legislation < ActiveRecord::Base
  attr_accessible :value,
                  :value_unprocessed,
                  :number,
                  :year,
                  :name,
                  :paragraph,
                  :section,
                  :letter

  has_many :paragraph_mappings, class_name: :LegislationParagraphMapping

  has_many :paragraph_names, through: :paragraph_mappings

  has_many :usages, class_name: :LegislationUsage,
                    foreign_key: :legislation_usage_id

  has_many :decrees, through: :usages

  def title
    LegislationTitle.find_by_paragraph_and_letter(paragraph, letter)
  end
end
