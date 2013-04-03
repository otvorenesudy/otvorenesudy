class Judge < ActiveRecord::Base
  include Resource::Similarity

  include Tire::Model::Search

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

  scope :chair,     joins(:positions).merge(JudgePosition.chair)
  scope :vicechair, joins(:positions).merge(JudgePosition.vicechair)

  scope :chaired, joins(:judgings).merge(Judging.chaired)

  max_paginates_per 100
      paginates_per 25

  has_many :employments, dependent: :destroy, order: :'active desc'

  has_many :courts, through: :employments

  has_many :positions, through: :employments, source: :judge_position

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

  def active_at(court)
    employments.at_court(court).active.any?
  end

  alias :active?    :active
  alias :active_at? :active_at
end
