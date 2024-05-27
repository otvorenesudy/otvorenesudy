class Decree < ActiveRecord::Base
  include Resource::URI
  include Resource::Storage
  include Resource::Subscribable

  include Probe

  include Judge::Matched

  attr_accessible :case_number, :file_number, :date, :ecli, :summary

  scope :at_court, lambda { |court| where court_id: court }

  scope :during_employment,
        lambda { |employment|
          where(court_id: employment.court).joins(:judgements).merge(Judgement.of_judge(employment.judge))
        }

  belongs_to :proceeding

  belongs_to :court

  has_many :judgements, dependent: :destroy
  # TODO remove conditions in favor of scope in Rails >= 4
  has_many :inexact_judgements, class_name: :Judgement, conditions: Judgement.inexact_conditions

  has_many :judges, through: :judgements
  # TODO remove conditions in favor of scope in Rails >= 4
  has_many :exact_judges,
           through: :judgements,
           source: :judge,
           class_name: :Judge,
           conditions: Judgement.exact_conditions,
           order: 'judges.last, judges.middle, judges.first'

  belongs_to :form, class_name: :DecreeForm, foreign_key: :decree_form_id

  has_many :naturalizations, class_name: :DecreeNaturalization, dependent: :destroy

  has_many :natures, class_name: :DecreeNature, through: :naturalizations

  has_many :legislation_area_usages, dependent: :destroy
  has_many :legislation_areas, through: :legislation_area_usages

  has_many :legislation_subarea_usages, dependent: :destroy
  has_many :legislation_subareas, through: :legislation_subarea_usages

  has_many :legislation_usages, dependent: :destroy

  has_many :legislations, through: :legislation_usages

  has_many :paragraph_explanations, through: :legislations

  has_many :paragraphs, through: :paragraph_explanations

  has_many :pages, class_name: :DecreePage, dependent: :destroy

  max_paginates_per 100
  paginates_per 20

  mapping do
    map :id

    analyze :case_number
    analyze :file_number
    analyze :date, type: :date
    analyze :ecli
    analyze :summary
    analyze :text, as: lambda { |d| d.text }, index: :no
    analyze :pages_count, type: :integer, as: lambda { |d| d.pages.count }
    analyze :court, as: lambda { |d| d.court.name if d.court }
    analyze :court_type, as: lambda { |d| d.court.type.value if d.court }
    analyze :judges, as: lambda { |d| d.judge_names }
    analyze :form, as: lambda { |d| d.form.value if d.form }
    analyze :natures, as: lambda { |d| d.natures.pluck(:value) }
    analyze :legislation_areas, as: lambda { |d| d.legislation_areas.pluck(:value) }
    analyze :legislation_subareas, as: lambda { |d| d.legislation_subareas.pluck(:value) }
    analyze :legislations, as: lambda { |d| d.legislations.map { |l| l.value '%u/%y/%p' } }

    sort_by :date, :created_at, :pages_count
  end

  facets do
    facet :q, type: :fulltext, field: :all, highlights: :text
    facet :judges, type: :terms
    facet :legislation_areas, type: :terms, size: LegislationArea.count
    facet :legislation_subareas, type: :terms, size: LegislationSubarea.count
    facet :natures, type: :terms, size: DecreeNature.count
    facet :form, type: :terms
    facet :court_type, type: :terms
    facet :court, type: :terms
    facet :date, type: :date, interval: :month
    facet :legislations, type: :terms
    facet :file_number, type: :terms
    facet :case_number, type: :terms
    facet :pages_count, type: :range, ranges: [1..1, 2..2, 3..5, 5..10]
  end

  def text
    @text ||= pages.pluck(:text).join
  end

  def time
    @time ||= date.to_datetime.end_of_day if date
  end

  def judge_names
    @judge_names ||= Judge::Names.of judges
  end

  def legislation_areas_and_subareas
    @legislation_areas_and_subareas ||= [*legislation_areas, *legislation_subareas].compact
  end

  def pdf_uri_valid?
    pdf_uri && !pdf_uri_invalid
  end

  def has_future_date?
    date > Time.now.to_date unless date.nil?
  end

  def had_future_date?
    date > created_at.to_date unless date.nil?
  end

  def unprocessed?
    court.nil? || judgements.none?
  end

  def similar
    return [] if embedding.blank?

    Decree.where('decrees.id != ?', id).order("decrees.embedding <=> '#{embedding}' ASC").limit(25).to_a
  end

  def seo_keywords
    companies = text ? text.gsub(/[[:space:]]+/, ' ').squeeze(' ').scan(/.{3,30}s\.r\.o/) : []

    companies
  end

  def formatted_text
    text ? text.gsub(/(?>\r\n|\n|\f|\r|\u2028|\u2029)/, "\n") : ''
  end

  before_save :invalidate_caches

  def invalidate_caches
    legislations.each { |legislation| legislation.invalidate_caches }

    @text = @time = @judge_names = @legislation_areas_and_subareas = nil
  end

  storage :resource, JusticeGovSk::Storage::DecreePage, extension: :html
  storage :document, JusticeGovSk::Storage::DecreeDocument, extension: :pdf
  storage :image, JusticeGovSk::Storage::DecreeImage, extension: :pdf
end
