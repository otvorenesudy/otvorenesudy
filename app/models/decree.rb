# frozen_string_literal: true

class Decree < ApplicationRecord
  include Resource::URI
  include Resource::Subscribable

  include Probe

  include Judge::Matched

  has_neighbors :embedding

  scope :at_court, ->(court) { where(court_id: court) }

  scope :during_employment, lambda { |employment|
    where(court_id: employment.court).joins(:judgements).merge(Judgement.of_judge(employment.judge))
  }

  belongs_to :proceeding, optional: true
  belongs_to :court, optional: true

  has_many :judgements, dependent: :destroy
  has_many :inexact_judgements, -> { inexact }, class_name: 'Judgement', inverse_of: :decree, dependent: nil

  has_many :judges, through: :judgements
  has_many :exact_judges,
           -> { where(judgements: { judge_name_similarity: 1.0 }).order(:last, :middle, :first) },
           through: :judgements,
           source: :judge

  belongs_to :form, class_name: 'DecreeForm', foreign_key: :decree_form_id, optional: true, inverse_of: :decrees

  has_many :naturalizations, class_name: 'DecreeNaturalization', dependent: :destroy
  has_many :natures, class_name: 'DecreeNature', through: :naturalizations

  has_many :legislation_area_usages, dependent: :destroy
  has_many :legislation_areas, through: :legislation_area_usages

  has_many :legislation_subarea_usages, dependent: :destroy
  has_many :legislation_subareas, through: :legislation_subarea_usages

  has_many :legislation_usages, dependent: :destroy
  has_many :legislations, through: :legislation_usages
  has_many :paragraph_explanations, through: :legislations
  has_many :paragraphs, through: :paragraph_explanations

  has_many :pages, class_name: 'DecreePage', dependent: :destroy

  before_save :invalidate_caches

  max_paginates_per 100
  paginates_per 20

  mapping do
    map :id

    analyze :case_number
    analyze :file_number
    analyze :date, type: :date
    analyze :ecli
    analyze :summary
    analyze :text, as: lambda(&:text), index: :no
    analyze :pages_count, type: :integer, as: ->(decree) { decree.pages.count }
    analyze :court, as: ->(decree) { decree.court&.name }
    analyze :court_type, as: ->(decree) { decree.court&.type&.value }
    analyze :judges, as: lambda(&:judge_names)
    analyze :form, as: ->(decree) { decree.form&.value }
    analyze :natures, as: ->(decree) { decree.natures.pluck(:value) }
    analyze :legislation_areas, as: ->(decree) { decree.legislation_areas.pluck(:value) }
    analyze :legislation_subareas, as: ->(decree) { decree.legislation_subareas.pluck(:value) }
    analyze :legislations, as: ->(decree) { decree.legislations.map { |legislation| legislation.value('%u/%y/%p') } }

    sort_by :date, :created_at, :pages_count
  end

  facets do
    facet :q, type: :fulltext, field: :all, highlights: :text
    facet :judges, type: :terms
    facet :legislation_areas, type: :terms, size: -> { LegislationArea.count }
    facet :legislation_subareas, type: :terms, size: -> { LegislationSubarea.count }
    facet :natures, type: :terms, size: -> { DecreeNature.count }
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
    @time ||= date&.to_datetime&.end_of_day
  end

  def judge_names
    @judge_names ||= Judge::Names.of(judges)
  end

  def legislation_areas_and_subareas
    @legislation_areas_and_subareas ||= [*legislation_areas, *legislation_subareas].compact
  end

  def pdf_uri_valid?
    pdf_uri.present? && !pdf_uri_invalid
  end

  def future_date?
    date > Time.zone.today unless date.nil?
  end

  def future_date_when_created?
    date > created_at.to_date unless date.nil?
  end

  def unprocessed?
    court.nil? || judgements.none?
  end

  # The 25 decrees nearest by meaning: the cosine distance of the embeddings otvorenesudy-api computes.
  def similar
    return [] if embedding.blank?

    nearest_neighbors(:embedding, distance: 'cosine').first(25)
  end

  # Companies the decree names (seo keywords for its page).
  def seo_keywords
    text.gsub(/[[:space:]]+/, ' ').squeeze(' ').scan(/.{3,30}s\.r\.o/)
  end

  def formatted_text
    text.gsub(/(?>\r\n|\n|\f|\r| | )/, "\n")
  end

  def invalidate_caches
    legislations.each(&:invalidate_caches)

    @text = @time = @judge_names = @legislation_areas_and_subareas = nil
  end
end
