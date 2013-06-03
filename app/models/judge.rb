# encoding: utf-8

class Judge < ActiveRecord::Base
  include Resource::URI
  include Resource::Similarity

  include Document::Indexable
  include Document::Searchable
  include Document::Suggestable

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

  belongs_to :source

  has_many :designations, class_name: :JudgeDesignation, dependent: :destroy

  has_many :employments, dependent: :destroy, order: :'active desc'

  has_many :courts, through: :employments

  has_many :positions, through: :employments, source: :judge_position

  has_many :judgings, dependent: :destroy

  has_many :hearings, through: :judgings

  has_many :judgements, dependent: :destroy

  has_many :decrees, through: :judgements

  has_many :property_declarations, class_name: :JudgePropertyDeclaration,
                                   dependent: :destroy

  has_many :related_persons, class_name: :JudgeRelatedPerson,
                             through: :property_declarations

  has_many :statistical_summaries, class_name: :JudgeStatisticalSummary,
                                   dependent: :destroy

  validates :name, presence: true

  mapping do
    map     :id
    analyze :name
    analyze :activity,                  as: lambda { |j| j.active ? :active : :inactive }
    analyze :positions,                 as: lambda { |j| j.positions.pluck(:value) }
    analyze :courts,                    as: lambda { |j| j.courts.pluck(:name) }
    analyze :hearings,  type: :integer, as: lambda { |j| j.hearings.count }
    analyze :decrees,   type: :integer, as: lambda { |j| j.decrees.count }
  end

  facets do
    facet :name,           type: :terms, countless: true
    facet :activity,       type: :terms
    facet :positions,      type: :terms
    facet :courts,         type: :terms
    facet :hearings_count, type: :range, field: :hearings, ranges: [10..50, 50..100, 100..1000]
    facet :decrees_count,  type: :range, field: :decrees,  ranges: [10..50, 50..100, 100..500, 500..1000]
  end

  def probably_superior_court_officer?
    source == Source.of(JusticeGovSk) && !listed?
  end
  
  def probably_woman?
    last.end_with? 'ová'
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

  def to_context_query
    query     = "sud \"#{self.first} #{self.middle} #{self.last}\""
    sites     = %w(sme.sk tyzden.sk webnoviny.sk tvnoviny.sk pravda.sk etrend.sk aktualne.sk)
    blacklist = %w(http://www.sme.sk/diskusie/ blog.sme.sk)

    "#{query} site:(#{sites.join(' OR ')}) #{blacklist.map { |e| "-site:#{e}" }.join(' ')}"
  end
end
