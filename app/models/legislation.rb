class Legislation < ActiveRecord::Base
  attr_accessible :value,
                  :value_unprocessed,
                  :number,
                  :year,
                  :name,
                  :paragraph,
                  :section,
                  :letter

  belongs_to :name, class_name: :LegislationName

  has_many :usages, class_name: :LegislationUsage,
                    foreign_key: :legislation_usage_id

  has_many :decrees, through: :usages
end
