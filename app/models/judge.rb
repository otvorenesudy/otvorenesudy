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

  scope :active,   joins(:judge_positions).merge(Employment.active)
  scope :inactive, joins(:judge_positions).merge(Employment.inactive)
  
  scope :chair,     joins(:judge_positions).merge(JudgePosition.chair)
  scope :vicechair, joins(:judge_positions).merge(JudgePosition.vicechair)
  
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
