# frozen_string_literal: true

class JudgeIncome < ApplicationRecord
  belongs_to :property_declaration, class_name: 'JudgePropertyDeclaration',
                                    foreign_key: :judge_property_declaration_id,
                                    inverse_of: false,
                                    optional: true

  validates :description, presence: true
  validates :value,       presence: true
end
