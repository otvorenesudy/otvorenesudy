# encoding: utf-8

class Judge < ActiveRecord::Base
  include Resource::URI
  include Resource::ContextSearch
  include Resource::Similarity
  include Resource::Storage

  include Probe::Index
  include Probe::Search
  include Probe::Suggest

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

  scope :normal,  where('judgings.judge_chair = false').order(:name)
  scope :chaired, where('judgings.judge_chair = true').order(:name)

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

  max_paginates_per 100
      paginates_per 25

  mapping do
    map :id

    analyze :name
    analyze :activity,                       as: lambda { |j| j.active == nil ? :unknown : j.active ? :active : :inactive }
    analyze :positions,                      as: lambda { |j| j.positions.pluck(:value) }
    analyze :courts,                         as: lambda { |j| j.courts.pluck(:name) }
    analyze :hearings_count, type: :integer, as: lambda { |j| j.hearings.count }
    analyze :decrees_count,  type: :integer, as: lambda { |j| j.decrees.count }

    sort_by :_score, :hearings_count, :decrees_count
  end

  facets do
    facet :q,              field: [:name, :courts, :positions], type: :fulltext, highlight: true
    facet :activity,       type: :terms
    facet :positions,      type: :terms
    facet :courts,         type: :terms
    facet :hearings_count, type: :range, ranges: [10..50, 50..100, 100..1000]
    facet :decrees_count,  type: :range, ranges: [10..50, 50..100, 100..500, 500..1000]
  end
  
  def name(format = nil)
    return super() if format.nil? || format == '%p %f %m %l %a, %s'

    @name         ||= {}
    @name[format] ||= format.gsub(/\%[pfmlsa]/, name_parts).gsub(/(\W)\s+\z/, '').strip.squeeze(' ')
  end
  
  private
  
  def name_parts
    @name_parts ||= {
      '%p' => prefix,
      '%f' => first,
      '%m' => middle,
      '%l' => last,
      '%s' => suffix,
      '%a' => addition
    }
  end

  public

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

  def listed
    @listed ||= uri == JusticeGovSk::Request::JudgeList.url
  end

  alias :listed? :listed

  def probably_superior_court_officer
    @probably_officer ||= source == Source.of(JusticeGovSk) && !listed?
  end

  def probably_woman
    @probably_woman ||= [middle, last].reject(&:nil?).map { |v| v.end_with? 'ová' }.include? true
  end

  alias :probably_superior_court_officer? :probably_superior_court_officer
  alias :probably_woman?                  :probably_woman

  context_query { |judge| "sud \"#{judge.first} #{judge.middle} #{judge.last}\"" }

  context_options exclude: /www\.webnoviny\.sk\/.*\?from=.*\z/

  storage(:curriculum, JusticeGovSk::Storage::JudgeCurriculum) { |judge| "#{judge.name}.pdf" }
  storage(:cover_letter, JusticeGovSk::Storage::JudgeCoverLetter) { |judge| "#{judge.name}.pdf" }
end
