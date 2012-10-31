class LegislationSubarea < ActiveRecord::Base
  attr_accessible :value

  belongs_to :area, class_name: :LegislationArea
  
  has_many :decrees
             
  validates :value, presence: true
end
