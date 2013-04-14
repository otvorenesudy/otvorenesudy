class JudgeRelatedPerson < ActiveRecord::Base
  attr_accessible :name,
                  :institution,
                  :function
  
  belongs_to :property_declaration, class_name: :JudgePropertyDeclaration,
                                    foreign_key: :judge_property_declaration_id
             
  validates :name, presence: true
end
