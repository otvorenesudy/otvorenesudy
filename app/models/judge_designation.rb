class JudgeDesignations < ActiveRecord::Base
  attr_accessible :date

  belongs_to :judge
  belongs_to :judge_designation_type

  validates :date, presence: true
end
