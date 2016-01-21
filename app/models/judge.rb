# encoding: utf-8

class Judge < ActiveRecord::Base
  include Resource::URI
  include Resource::ContextSearch
  include Resource::Formatable
  include Resource::Indicator
  include Resource::Similarity
  include Resource::Storage

  include Probe

  attr_accessible :name,
                  :name_unprocessed,
                  :prefix,
                  :first,
                  :middle,
                  :last,
                  :suffix,
                  :addition

  include Judge::Activity
  include Judge::Matched
  include Judge::Indicators

  scope :not_active_or_not_listed, where('employments.active = false OR employments.active IS NULL OR uri != ?', JusticeGovSk::Request::JudgeList.url)

  scope :chair,     joins(:positions).merge(JudgePosition.chair)
  scope :vicechair, joins(:positions).merge(JudgePosition.vicechair)

  scope :normal,  where('judge_chair = false')
  scope :chaired, where('judge_chair = true')

  # TODO refactor!
  scope :listed, where(source_id: Source.of(JusticeGovSk).id).joins(:employments).where(:'employments.active' => [true, false])

  scope :with_related_people, lambda { joins(:related_people) }

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

  has_many :related_people, class_name: :JudgeRelatedPerson,
                            through: :property_declarations

  has_many :statistical_summaries, class_name: :JudgeStatisticalSummary,
                                   dependent: :destroy

  has_many :statistical_tables, through: :statistical_summaries,
                                source: :tables

  has_many :selection_procedure_commissioners
  has_many :selection_procedure_candidates

  validates :name, presence: true

  include Judge::ConstitutionalDecrees
  include Judge::Incomes
  include Judge::RelatedPeople
  include Judge::SubstantiationNotes

  indicate Judge::AppealCourtAcceptanceRate
  indicate Judge::UnfinishedIssuesCounts
  indicate Judge::UnfinishedIssuesRate
  indicate Judge::UnresolvedIssuesCounts

  max_paginates_per 100
      paginates_per 20

  mapping do
    map :id

    analyze :name
    analyze :activity,                              as: lambda { |j| j.active == nil ? :unknown : j.active ? :active : :inactive }
    analyze :positions,                             as: lambda { |j| j.positions.pluck(:value) }
    analyze :courts,                                as: lambda { |j| j.courts.pluck(:name) }
    analyze :hearings_count,        type: :integer, as: lambda { |j| j.hearings.exact.size }
    analyze :decrees_count,         type: :integer, as: lambda { |j| j.decrees.exact.size }
    analyze :related_people_count,  type: :integer, as: lambda { |j| j.related_people.group(:name).count.size }

    sort_by :_score, :hearings_count, :decrees_count
  end

  facets do
    facet :q,                    type: :fulltext, field: [:name], force_wildcard: true
    facet :activity,             type: :terms
    facet :positions,            type: :terms
    facet :courts,               type: :terms
    facet :hearings_count,       type: :range, ranges: [10..50, 50..100, 100..500, 500..1000]
    facet :decrees_count,        type: :range, ranges: [10..50, 50..100, 100..500, 500..1000]
    facet :related_people_count, type: :range, ranges: [1..1, 2..2, 3..5]
  end

  formatable :name, default: '%p %f %m %l %a, %s', remove: /\,\s*\z/ do |judge|
    { '%p' => judge.prefix,
      '%f' => judge.first,
      '%m' => judge.middle,
      '%l' => judge.last,
      '%s' => judge.suffix,
      '%a' => judge.addition }
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

  def listed
    @listed ||= (source == Source.of(JusticeGovSk) && active != nil)
  end

  alias :listed? :listed

  def probably_superior_court_officer
    @probably_officer ||= source == Source.of(JusticeGovSk) && !listed?
  end

  def probably_woman
    @probably_woman ||= [middle, last].reject(&:nil?).select { |v| v =~ /(ov|sk)á\z/ }.any?
  end

  alias :probably_superior_court_officer? :probably_superior_court_officer
  alias :probably_woman?                  :probably_woman

  context_query { |judge| "sud \"#{judge.first} #{judge.middle} #{judge.last}\"" }

  context_options exclude: /www\.webnoviny\.sk\/.*\?from=.*\z/

  before_save :invalidate_caches

  def invalidate_caches
    invalidate_context_query
    invalidate_name

    related_people.each { |person| person.invalidate_caches }

    @listed = @probably_officer = @probably_woman = nil
  end

  #TODO rm: this info is not in selection procedures
  storage(:curriculum, JusticeGovSk::Storage::JudgeCurriculum)    { |judge| "#{judge.name}.pdf" }
  storage(:cover_letter, JusticeGovSk::Storage::JudgeCoverLetter) { |judge| "#{judge.name}.pdf" }
end
