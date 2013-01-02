# encoding: utf-8

class Judge < ActiveRecord::Base
  include Resource::Similarity
  
  attr_accessible :name,
                  :name_unprocessed,
                  :prefix,
                  :first,
                  :middle,
                  :last,
                  :suffix,
                  :addition

  # TODO rm or mv to employments -- refactor!
  scope :active,   joins(:employments).where('active = true')
  scope :inactive, joins(:employments).where('active = false')
  
  scope :chair,     joins(:judge_positions).where('value = ? OR value = ?',    'predseda',    'predsedníčka')
  scope :vicechair, joins(:judge_positions).where('value = ? OR value = ?', 'podpredseda', 'podpredsedníčka')
  
  has_many :employments, dependent: :destroy
  
  has_many :judge_positions, through: :employments
  
  has_many :judgings, dependent: :destroy
  
  has_many :hearings, through: :judgings,
                      dependent: :destroy
  
  has_many :judgements, dependent: :destroy
  
  has_many :decrees, through: :judgements,
                     dependent: :destroy
  
  validates :name, presence: true
end
