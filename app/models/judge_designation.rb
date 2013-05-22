class JudgeDesignation < ActiveRecord::Base
  attr_accessible :date

  belongs_to :judge
  
  belongs_to :type, class_name: :JudgeDesignationType, foreign_key: :judge_designation_type_id

  validates :date, presence: true
end
