class Hearing < ActiveRecord::Base
  attr_accessible :case_number,
                  :file_number,
                  :date,
                  :room,
                  :special_type,
                  :commencement_date,
                  :selfjudge,
                  :note
  
  belongs_to :proceeding
  
  belongs_to :court
  
  has_many :judgings, dependent: :destroy
  
  has_many :judges, through: :judgings
  
  belongs_to :type,    class_name: :HearingType
  belongs_to :section, class_name: :HearingSection
  belongs_to :subject, class_name: :HearingSubject
  belongs_to :form,    class_name: :HearingForm
  
  belongs_to :chair_judge, class_name: :Judge
  
  has_many :proposers,  dependent: :destroy
  has_many :opponents,  dependent: :destroy
  has_many :defendants, dependent: :destroy
end
