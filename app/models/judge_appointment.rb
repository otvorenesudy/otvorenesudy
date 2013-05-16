class JudgeAppointment < ActiveRecord::Base
  attr_accessible :date
  
  belongs_to :judge
  
  validates :date, presence: true
end
