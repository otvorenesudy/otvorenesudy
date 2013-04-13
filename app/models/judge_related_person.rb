class JudgeRelatedPerson < ActiveRecord::Base
  attr_accessible :name,
                  :institution,
                  :function
  
  has_many :property_declarations, class_name: :JudgePropertyDeclaration,
                                   foreign_key: :judge_property_declaration_id
             
  validates :name,        presence: true
  validates :institution, presence: true
  validates :function,    presence: true
end
