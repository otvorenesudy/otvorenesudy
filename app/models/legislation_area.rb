class LegislationArea < ActiveRecord::Base
  attr_accessible :value

  # TODO: Fix destroy method, should be with argument
  has_many :subareas, class_name: :LegislationSubarea
                      #dependent: destroy
  
  has_many :decrees
             
  validates :value, presence: true
end
