class JudgePropertyList < ActiveRecord::Base
  belong_to :declaration, class_name: :JudgePropertyDeclaration,
                          foreign_key: :judge_property_declaration_id

  belong_to :category, class_name: :JudgePropertyCategory,
                       foreign_key: :judge_property_category_id

  has_many :items, class_name: :JudgeProperty,
                   dependent: :destroy
end
