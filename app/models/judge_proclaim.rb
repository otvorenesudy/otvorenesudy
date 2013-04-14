class JudgeProclaim < ActiveRecord::Base
  belongs_to :property_declaration, class_name: :JudgePropertyDeclaration,
                                    foreign_key: :judge_property_declaration_id
                                   
  belongs_to :statement, class_name: :JudgeStatement, 
                         foreign_key: :judge_statement_id
end
