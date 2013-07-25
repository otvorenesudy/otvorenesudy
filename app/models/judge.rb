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

  scope :active,   joins(:employments).merge(Employment.active)
  scope :inactive, joins(:employments).merge(Employment.inactive)

  scope :chair,     joins(:positions).merge(JudgePosition.chair)
  scope :vicechair, joins(:positions).merge(JudgePosition.vicechair)

  scope :normal,  where('judge_chair = false')
  scope :chaired, where('judge_chair = true')

  scope :by_related_persons, lambda { joins(:related_persons).group('judge_property_declarations.judge_id').order('count_all desc') }

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

  has_many :statistical_tables, through: :statistical_summaries,
                                source: :tables

  validates :name, presence: true

  include Judge::ConstitutionalDecrees
  include Judge::Incomes
  include Judge::Matched
  include Judge::RelatedPersons
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
    analyze :hearings_count,        type: :integer, as: lambda { |j| j.hearings.count }
    analyze :decrees_count,         type: :integer, as: lambda { |j| j.decrees.count }
    analyze :related_persons_count, type: :integer, as: lambda { |j| j.related_persons.group(:name).count.size }

    sort_by :_score, :hearings_count, :decrees_count
  end

  facets do
    facet :q,                     type: :fulltext, field: [:name], force_wildcard: true
    facet :activity,              type: :terms
    facet :positions,             type: :terms
    facet :courts,                type: :terms
    facet :hearings_count,        type: :range, ranges: [10..50, 50..100, 100..500, 500..1000]
    facet :decrees_count,         type: :range, ranges: [10..50, 50..100, 100..500, 500..1000]
    facet :related_persons_count, type: :range, ranges: [1..1, 2..2, 3..5, 6..10]
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

  storage(:curriculum, JusticeGovSk::Storage::JudgeCurriculum)    { |judge| "#{judge.name}.pdf" }
  storage(:cover_letter, JusticeGovSk::Storage::JudgeCoverLetter) { |judge| "#{judge.name}.pdf" }
end
