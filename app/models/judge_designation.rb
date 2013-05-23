class JudgeDesignation < ActiveRecord::Base
  attr_accessible :date, :uri

  belongs_to :judge
  belongs_to :source
  belongs_to :type,  class_name: :JudgeDesignationType, foreign_key: :judge_designation_type_id

  validates :date, presence: true
  validates :uri,  presence: true
end
