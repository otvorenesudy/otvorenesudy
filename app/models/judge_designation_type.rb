class JudgeDesignationType < ApplicationRecord

  has_many :designations, class_name: :JudgeDesignation

  validates :value, presence: true
end
