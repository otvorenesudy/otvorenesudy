class Hearing < ActiveRecord::Base
  attr_accessible :uri,
                  :case_number,
                  :file_number,
                  :date,
                  :room,
                  :special_type,
                  :commencement_date,
                  :chair_judge_matched_exactly,
                  :chair_judge_name_unprocessed,
                  :selfjudge,
                  :note
  
  belongs_to :proceeding
  
  belongs_to :court
  
  has_many :judgings, dependent: :destroy
  
  has_many :judges, through: :judgings
  
  belongs_to :type,    class_name: :HearingType,    foreign_key: :hearing_type_id
  belongs_to :section, class_name: :HearingSection, foreign_key: :hearing_section_id
  belongs_to :subject, class_name: :HearingSubject, foreign_key: :hearing_subject_id
  belongs_to :form,    class_name: :HearingForm,    foreign_key: :hearing_form_id
  
  belongs_to :chair_judge, class_name: :Judge, foreign_key: :chair_judge_id
  
  has_many :proposers,  dependent: :destroy
  has_many :opponents,  dependent: :destroy
  has_many :defendants, dependent: :destroy
end
