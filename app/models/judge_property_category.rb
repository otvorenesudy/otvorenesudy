class JudgePropertyCategory < ActiveRecord::Base
  attr_accessible :value
  
  has_many :property_lists, class_name: :JudgePropertyList,
                            foreign_key: :judge_property_list_id
             
  validates :value, presence: true
end
