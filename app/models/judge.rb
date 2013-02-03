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

  scope :active,   joins(:employments).merge(Employment.active)
  scope :inactive, joins(:employments).merge(Employment.inactive)
  
  scope :chair,     joins(:judge_positions).merge(JudgePosition.chair)
  scope :vicechair, joins(:judge_positions).merge(JudgePosition.vicechair)
  
  paginates_per 25
  max_paginates_per 100
  
  has_many :employments, dependent: :destroy, order: :'active desc'
  
  has_many :courts, through: :employments
  
  has_many :judge_positions, through: :employments
  
  has_many :judgings, dependent: :destroy
  
  has_many :hearings, through: :judgings,
                      dependent: :destroy
  
  has_many :judgements, dependent: :destroy
  
  has_many :decrees, through: :judgements,
                     dependent: :destroy
  
  validates :name, presence: true
  
  def active
    employments.active.any?
  end
  
  alias :active? :active
end
