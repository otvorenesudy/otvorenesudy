class Judge < ActiveRecord::Base
  attr_accessible :name

  has_many :employments, dependent: :destroy
  
  has_many :judgings, dependent: :destroy
  
  has_many :hearings, through: :judgings,
                      dependent: :destroy
  
  has_many :chaired_hearings, class_name: :Hearing,
                              foreign_key: :chair_judge_id,
                              dependent: :destroy
  
  has_many :decrees, dependent: :destroy
             
  validates :name, presence: true
end
