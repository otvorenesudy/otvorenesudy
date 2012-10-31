class Decree < ActiveRecord::Base
  attr_accessible :case_number,
                  :file_number,
                  :date,
                  :ecli
  
  belongs_to :proceeding
  
  belongs_to :court
  belongs_to :judge
  
  belongs_to :nature, class_name: :DecreeNature
  belongs_to :form,   class_name: :DecreeForm
  
  belongs_to :legislation_area
  belongs_to :legislation_subarea
  
  has_many :legislation_usages
  
  has_many :legislations, through: :legislation_usages
end
