class Decree < ActiveRecord::Base
  attr_accessible :uri,
                  :case_number,
                  :file_number,
                  :date,
                  :ecli
  
  belongs_to :proceeding
  
  belongs_to :court
  belongs_to :judge
  
  belongs_to :nature, class_name: :DecreeNature,
                      foreign_key: :decree_nature_id
  
  belongs_to :form, class_name: :DecreeForm,
                    foreign_key: :decree_form_id
  
  belongs_to :legislation_area
  belongs_to :legislation_subarea
  
  has_many :legislation_usages
  
  has_many :legislations, through: :legislation_usages
end
