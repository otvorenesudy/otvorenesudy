# encoding: utf-8

class Judge < ActiveRecord::Base
  attr_accessible :name,
                  :name_unprocessed,
                  :prefix,
                  :first,
                  :middle,
                  :last,
                  :suffix,
                  :addition

  scope :active,   joins(:employments).where('active = true')
  scope :inactive, joins(:employments).where('active = false')
  
  scope :chair,     joins(:judge_positions).where('value = ? OR ?',    'predseda',    'predsedníčka')
  scope :vicechair, joins(:judge_positions).where('value = ? OR ?', 'podpredseda', 'podpredsedníčka')
  
  has_many :employments, dependent: :destroy
  
  has_many :judge_positions, through: :employments
  
  has_many :judgings, dependent: :destroy
  
  has_many :hearings, through: :judgings,
                      dependent: :destroy
  
  has_many :chaired_hearings, class_name: :Hearing,
                              foreign_key: :chair_judge_id,
                              dependent: :destroy
  
  has_many :decrees, dependent: :destroy
             
  validates :name, presence: true
end
