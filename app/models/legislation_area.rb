class LegislationArea < ActiveRecord::Base
  attr_accessible :value

  has_many :subareas, class_name: :LegislationSubarea,
                      dependent: :destroy
  
  has_many :decrees
             
  validates :value, presence: true
end
