class JudgeDesignationType < ActiveRecord::Base
  attr_accessible :value

  has_many :designations, class_name: :JudgeDesignation

  validates :value, presence: true
end
