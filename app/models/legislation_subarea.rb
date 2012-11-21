class LegislationSubarea < ActiveRecord::Base
  attr_accessible :value

  belongs_to :area, class_name: :LegislationArea,
                    foreign_key: :legislation_area_id
  
  has_many :decrees
             
  validates :value, presence: true
end
