# encoding: utf-8

class Court < ActiveRecord::Base
  include Resource::URI
  include Resource::ContextSearch
  include Resource::Formatable
  include Resource::Storage
  include Resource::Indicator

  include Probe

  attr_accessible :name,
                  :street,
                  :phone,
                  :fax,
                  :media_person,
                  :media_person_unprocessed,
                  :media_phone,
                  :latitude,
                  :longitude

  scope :by_type, lambda { |court_type| where('court_type_id = ?', court_type.id) }

  belongs_to :type, class_name: :CourtType, foreign_key: :court_type_id

  has_many :employments, dependent: :destroy

  has_many :judges, through: :employments

  has_many :hearings, dependent: :destroy
  has_many :decrees,  dependent: :destroy

  belongs_to :jurisdiction, class_name: :CourtJurisdiction

  belongs_to :municipality

  has_many :offices, class_name: :CourtOffice, dependent: :destroy

  belongs_to :information_center,       class_name: :CourtOffice, dependent: :destroy
  belongs_to :registry_center,          class_name: :CourtOffice, dependent: :destroy
  belongs_to :business_registry_center, class_name: :CourtOffice, dependent: :destroy

  has_many :expenses, class_name: :CourtExpense,
                      dependent: :destroy

  has_many :statistical_summaries, class_name: :CourtStatisticalSummary,
                                   dependent: :destroy

  validates :name,   presence: true
  validates :street, presence: true

  indicate Court::AverageProceedingLengths

  acts_as_gmappable lat: :latitude, lng: :longitude, process_geocoding: false

  max_paginates_per 100
      paginates_per 20

  mapping do
    map :id

    analyze :name
    analyze :street
    analyze :media_person
    analyze :type,                           as: lambda { |c| c.type.value }
    analyze :judges,                         as: lambda { |c| c.judges.pluck(:name) }
    analyze :judges_count,   type: :integer, as: lambda { |c| c.judges.count }
    analyze :hearings_count, type: :integer, as: lambda { |c| c.hearings.count }
    analyze :decrees_count,  type: :integer, as: lambda { |c| c.decrees.count }
    analyze :municipality,                   as: lambda { |c| c.municipality.name }
    analyze :expenses,       type: :integer, as: lambda { |c| c.expenses_total }

    sort_by :_score, :judges_count, :hearings_count, :decrees_count
  end

  facets do
    facet :q,              type: :fulltext, field: [:type, :name, :street, :municipality]
    facet :type,           type: :terms
    facet :municipality,   type: :terms
    facet :hearings_count, type: :range, ranges: [10..50, 50..100, 100..500, 500..1000]
    facet :decrees_count,  type: :range, ranges: [10..50, 50..100, 100..500, 500..1000]
    facet :judges_count,   type: :range, ranges: [5..10, 10..20, 20..50, 50..100]
    facet :expenses,       type: :range, ranges: [1000..10_000, 10_000..20_000, 20_000..50_000, 50_000..100_000]
  end

  formatable :address, default: '%s, %z %m', remove: /\,\s*\z/ do |court|
    { '%s' => court.street,
      '%z' => court.municipality.zipcode,
      '%m' => court.municipality.name,
      '%c' => 'Slovenská republika' }
  end

  def coordinates
    @coordinates ||= { latitude: latitude, longitude: longitude }
  end

  def chair
    @chair ||= judges.active.chair.first
  end

  def vicechair
    @vicechair ||= judges.active.vicechair.first
  end

  def expenses_total
    @expenses_total ||= expenses.sum :value
  end

  context_query { |court| "\"#{court.name}\"" }

  storage :resource, JusticeGovSk::Storage::CourtPage, extension: :html
end
