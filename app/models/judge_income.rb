class JudgeIncome < ActiveRecord::Base
  attr_accessible :description, :value

  belongs_to :property_declaration, class_name: :JudgePropertyDeclaration,
                                    foreign_key: :judge_property_declaration_id

  validates :description, presence: true
  validates :value,       presence: true
end
