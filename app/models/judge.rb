# frozen_string_literal: true

class Judge < ApplicationRecord
  include Resource::URI
  include Resource::Formatable
  include Resource::Indicator
  include Resource::Similarity

  include Probe

  include Judge::Activity
  include Judge::Matched
  include Judge::Indicators2013
  include Judge::Indicators2015
  include Judge::Indicators2017
  include Judge::Indicators2021

  # The list of judges justice.gov.sk published until 2019; judges imported from it carry this address.
  LIST_URI = 'http://www.justice.gov.sk/Stranky/Sudcovia/SudcaZoznam.aspx'

  scope :inactive_or_unlisted, lambda {
    where('employments.active = false OR employments.active IS NULL OR judges.uri != ?', LIST_URI)
  }

  scope :chair, -> { joins(:positions).merge(JudgePosition.chair) }
  scope :vicechair, -> { joins(:positions).merge(JudgePosition.vicechair) }
  scope :judicial_council_chair, -> { joins(:positions).merge(JudgePosition.judicial_council_chair) }
  scope :judicial_council_member, -> { joins(:positions).merge(JudgePosition.judicial_council_member) }

  scope :normal, -> { where('judge_chair = false') }
  scope :chaired, -> { where('judge_chair = true') }

  scope :listed, lambda {
    where(source: Source.of('JusticeGovSk')).joins(:employments).where(employments: { active: [true, false] })
  }

  has_many :designations, class_name: 'JudgeDesignation', dependent: :destroy
  has_many :employments, -> { order(active: :desc) }, dependent: :destroy, inverse_of: :judge
  has_many :courts, through: :employments
  has_many :positions, through: :employments, source: :judge_position

  has_many :judgings, dependent: :destroy
  has_many :hearings, through: :judgings

  has_many :judgements, dependent: :destroy
  has_many :decrees, through: :judgements

  has_many :property_declarations, class_name: 'JudgePropertyDeclaration', dependent: :destroy
  has_many :related_people, class_name: 'JudgeRelatedPerson', through: :property_declarations

  has_many :statistical_summaries, class_name: 'JudgeStatisticalSummary', dependent: :destroy
  has_many :statistical_tables, through: :statistical_summaries, source: :tables

  has_many :selection_procedure_commissioners, dependent: nil
  has_many :selection_procedure_candidates, dependent: nil

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
    analyze :sortable_name, as: ->(judge) { [judge.middle, judge.last, judge.first].compact.join(' ') }
    analyze :activity, as: ->(judge) { judge.activity }
    analyze :positions, as: ->(judge) { judge.positions.pluck(:value) }
    analyze :courts, as: ->(judge) { judge.courts.pluck(:name) }
    analyze :hearings_count, type: :integer, as: ->(judge) { judge.hearings.exact.size }
    analyze :decrees_count, type: :integer, as: ->(judge) { judge.decrees.exact.size }
    analyze :related_people_count, type: :integer, as: ->(judge) { judge.related_people.distinct.count(:name) }

    sort_by :sortable_name, :_score, :hearings_count, :decrees_count
  end

  facets do
    facet :q, type: :fulltext, field: [:name], force_wildcard: true
    facet :activity, type: :terms
    facet :positions, type: :terms
    facet :courts, type: :terms
    facet :hearings_count, type: :range, ranges: distribute(Hearing)
    facet :decrees_count, type: :range, ranges: distribute(Decree)
    facet :related_people_count, type: :range, ranges: [1..1, 2..2, 3..3]

    facet :name, type: :terms, visible: false, view: { results: 'judges/indicators/facets/name_results' }
    facet :similar_courts,
          type: :terms,
          field: :courts,
          visible: false,
          view: { results: 'judges/indicators/facets/terms_results' }
  end

  formatable :name, default: '%p %f %m %l %a, %s', fixes: ->(value) { value.sub(/,\s*\z/, '') } do |judge|
    {
      '%p' => judge.prefix,
      '%f' => judge.first,
      '%m' => judge.middle,
      '%l' => judge.last,
      '%s' => judge.suffix,
      '%a' => judge.addition
    }
  end

  before_save :invalidate_caches

  # true, false, or nil when no employment says.
  def active
    return true if employments.active.any?

    false if employments.inactive.any?
  end

  def active_at(court)
    return true if employments.at_court(court).active.any?

    false if employments.at_court(court).inactive.any?
  end

  alias active? active
  alias active_at? active_at

  def activity
    return :unknown if active.nil?

    active ? :active : :inactive
  end

  def incomplete?
    employments.at_court_by_type(CourtType.supreme).any? || employments.at_court_by_type(CourtType.regional).any?
  end

  alias incomplete incomplete?

  def listed
    @listed ||= source == Source.of('JusticeGovSk') && !active.nil?
  end

  alias listed? listed

  def probable_gender
    probably_female? ? :female : :male
  end

  def probably_higher_court_official
    @probably_higher_court_official ||= source == Source.of('JusticeGovSk') && !listed?
  end

  def probably_female
    @probably_female ||= [middle, last].compact.any? { |name| name.match?(/(ov|sk)á\z/) }
  end

  alias probably_higher_court_official? probably_higher_court_official
  alias probably_female? probably_female

  def invalidate_caches
    invalidate_name

    related_people.each(&:invalidate_caches)

    @listed = @probably_higher_court_official = @probably_female = nil
  end
end
