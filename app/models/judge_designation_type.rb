class JudgeDesignationType < ActiveRecord::Base
  attr_accessible :value

  has_many :judge_designations

  validates :value, presence: true
end
