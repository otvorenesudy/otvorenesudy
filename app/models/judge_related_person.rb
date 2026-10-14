# frozen_string_literal: true

class JudgeRelatedPerson < ApplicationRecord
  belongs_to :property_declaration, class_name: 'JudgePropertyDeclaration',
                                    foreign_key: :judge_property_declaration_id,
                                    inverse_of: false,
                                    optional: true

  validates :name, presence: true

  def known_judge?
    @known_judge ||= !to_judge.nil?
  end

  def to_judge
    return @to_judge if defined?(@to_judge)

    @to_judge = Judge.find_by(name: name)
  end

  before_save :invalidate_caches

  def invalidate_caches
    @known_judge = nil

    remove_instance_variable(:@to_judge) if defined?(@to_judge)
  end
end
