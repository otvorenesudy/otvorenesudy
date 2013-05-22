class Judge < ActiveRecord::Base
  include Resource::Uri
  include Resource::Similarity

  include Tire::Model::Search

  attr_accessible :uri,
                  :name,
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

  belongs_to :source

  has_many :designations, class_name: :JudgeDesignation, dependent: :destroy

  has_many :employments, dependent: :destroy, order: :'active desc'

  has_many :courts, through: :employments

  has_many :positions, through: :employments, source: :judge_position

  has_many :judgings, dependent: :destroy

  has_many :hearings, through: :judgings,
                      dependent: :destroy

  has_many :judgements, dependent: :destroy

  has_many :decrees, through: :judgements,
                     dependent: :destroy

  has_many :property_declarations, class_name: :JudgePropertyDeclaration,
                                   dependent: :destroy

  validates :name, presence: true

  def probably_superior_court_officer?
    source == Source.of(JusticeGovSk) && !listed?
  end

  def listed?
    uri == JusticeGovSk::Request::JudgeList.url
  end

  def active
    return true  if employments.active.any?
    return false if employments.inactive.any?
  end

  def active_at(court)
    return true  if employments.at_court(court).active.any?
    return false if employments.at_court(court).inactive.any?
  end

  alias :active?    :active
  alias :active_at? :active_at
end
