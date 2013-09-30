class JudgeRelatedPerson < ActiveRecord::Base
  attr_accessible :name,
                  :institution,
                  :function

  belongs_to :property_declaration, class_name: :JudgePropertyDeclaration,
                                    foreign_key: :judge_property_declaration_id

  validates :name, presence: true
  
  def known_judge?
    @known ||= !to_judge.nil?
  end
  
  def to_judge
    @judge ||= Judge.find_by_name(name)
  end

  before_save :invalidate_caches

  def invalidate_caches
    @known = @judge = nil
  end
end
