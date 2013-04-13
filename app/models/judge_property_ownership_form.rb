class JudgePropertyOwnershipForm < ActiveRecord::Base
  attr_accessible :value
  
  has_many :properties, class_name: :JudgeProperty,
                        foreign_key: :judge_property_id
             
  validates :value, presence: true
end
