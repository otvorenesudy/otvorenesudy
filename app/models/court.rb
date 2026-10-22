# frozen_string_literal: true

class Court < ApplicationRecord
  include Resource::URI
  include Resource::Formatable
  include Resource::Indicator

  include Probe

  scope :by_type, ->(court_types) { where(court_type_id: Array.wrap(court_types).map(&:id)) }

  belongs_to :type, class_name: 'CourtType', foreign_key: :court_type_id, inverse_of: :courts, optional: true

  has_many :employments, dependent: :destroy
  has_many :judges, -> { distinct }, through: :employments

  has_many :hearings, dependent: :destroy
  has_many :decrees, dependent: :destroy

  belongs_to :jurisdiction, class_name: 'CourtJurisdiction', optional: true
  belongs_to :municipality, optional: true

  has_many :offices, class_name: 'CourtOffice', dependent: :destroy

  belongs_to :information_center, class_name: 'CourtOffice', dependent: :destroy, optional: true
  belongs_to :registry_center, class_name: 'CourtOffice', dependent: :destroy, optional: true
  belongs_to :business_registry_center, class_name: 'CourtOffice', dependent: :destroy, optional: true

  has_many :expenses, class_name: 'CourtExpense', dependent: :destroy
  has_many :statistical_summaries, class_name: 'CourtStatisticalSummary', dependent: :destroy
  has_many :selection_procedures, dependent: :destroy

  validates :name, presence: true
  validates :street, presence: true

  indicate Court::AverageProceedingDurations

  max_paginates_per 100
  paginates_per 20

  mapping do
    map :id

    analyze :name
    analyze :street
    analyze :media_person
    analyze :type, as: ->(court) { court.type.value }
    analyze :judges, as: ->(court) { court.judges.pluck(:name) }
    analyze :judges_count, type: :integer, as: ->(court) { court.judges.count }
    analyze :hearings_count, type: :integer, as: ->(court) { court.hearings.count }
    analyze :decrees_count, type: :integer, as: ->(court) { court.decrees.count }
    analyze :municipality, as: ->(court) { court.municipality.name }
    analyze :expenses, type: :integer, as: lambda(&:expenses_total)

    sort_by :name, :_score, :judges_count, :hearings_count, :decrees_count
  end

  facets do
    facet :q, type: :fulltext, field: %i[type name street municipality judges]
    facet :type, type: :terms
    facet :municipality, type: :terms
    facet :hearings_count, type: :range, ranges: distribute(Hearing)
    facet :decrees_count, type: :range, ranges: distribute(Decree)
    facet :judges_count, type: :range, ranges: [5..10, 10..20, 20..50, 50..100]
    facet :expenses, type: :range, ranges: [1000..10_000, 10_000..20_000, 20_000..50_000, 50_000..100_000]
  end

  formatable :address, default: '%s, %z %m', fixes: ->(value) { value.sub(/,\s*\z/, '') } do |court|
    {
      '%s' => court.street,
      '%z' => court.municipality.zipcode,
      '%m' => court.municipality.name,
      '%c' => 'Slovenská republika'
    }
  end

  before_save :invalidate_caches

  def coordinates
    @coordinates ||= { latitude:, longitude: }
  end

  def chair
    @chair ||= chairs.first
  end

  def chairs
    @chairs ||= judges.active.chair
  end

  def vicechair
    @vicechair ||= vicechairs.first
  end

  def vicechairs
    @vicechairs ||= judges.active.vicechair
  end

  def judicial_council_chairs
    @judicial_council_chairs ||= judges.active.judicial_council_chair
  end

  def judicial_council_members
    @judicial_council_members ||= judges.active.judicial_council_member
  end

  def expenses_total
    @expenses_total ||= expenses.sum(:value)
  end

  def other_contacts
    @other_contacts ||= other_contacts_json ? JSON.parse(other_contacts_json, symbolize_names: true) : false
  end

  def invalidate_caches
    invalidate_address

    @coordinates = @chair = @chairs = @vicechair = @vicechairs = nil
    @judicial_council_chairs = @judicial_council_members = @expenses_total = @other_contacts = nil
  end
end
