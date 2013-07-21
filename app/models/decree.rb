# encoding: utf-8

class Decree < ActiveRecord::Base
  include Resource::URI
  include Resource::Storage
  include Resource::Subscribable

  include Probe

  attr_accessible :case_number,
                  :file_number,
                  :date,
                  :ecli,
                  :summary

  scope :at_court, lambda { |court| where court_id: court }

  scope :during_employment, lambda { |employment| where(court_id: employment.court).joins(:judgements).merge(Judgement.of_judge(employment.judge)) }

  belongs_to :proceeding

  belongs_to :court

  has_many :judgements, dependent: :destroy

  has_many :judges, through: :judgements

  belongs_to :form, class_name: :DecreeForm, foreign_key: :decree_form_id

  has_many :naturalizations, class_name: :DecreeNaturalization, dependent: :destroy

  has_many :natures, class_name: :DecreeNature, through: :naturalizations

  belongs_to :legislation_area
  belongs_to :legislation_subarea

  has_many :legislation_usages, dependent: :destroy

  has_many :legislations, through: :legislation_usages

  has_many :paragraph_explainations, through: :legislations

  has_many :paragraphs, through: :paragraph_explainations

  has_many :pages, class_name: :DecreePage, dependent: :destroy

  def text
    @text ||= pages.pluck(:text).join
  end

  max_paginates_per 100
      paginates_per 20

  mapping do
    map :id

    analyze :case_number
    analyze :file_number
    analyze :date,                type: :date
    analyze :ecli
    analyze :summary
    analyze :text,                                as: lambda { |d| d.text }
    analyze :court,                               as: lambda { |d| d.court.name if d.court }
    analyze :court_type,                          as: lambda { |d| d.court.type.value if d.court }
    analyze :judges,                              as: lambda { |d| d.judges.pluck(:name) }
    analyze :form,                                as: lambda { |d| d.form.value if d.form }
    analyze :natures,                             as: lambda { |d| d.natures.pluck(:value) }
    analyze :legislation_area,                    as: lambda { |d| d.legislation_area.value if d.legislation_area }
    analyze :legislation_subarea,                 as: lambda { |d| d.legislation_subarea.value if d.legislation_subarea }
    analyze :legislations,                        as: lambda { |d| d.legislations.map { |l| l.value '%u/%y/%p' } }
    analyze :pages_count,         type: :integer, as: lambda { |d| d.pages.count }

    sort_by :date, :created_at
  end

  facets do
    facet :q,                   type: :fulltext, field: :all, highlights: :text
    facet :judges,              type: :terms
    facet :legislation_area,    type: :terms, size: LegislationArea.count
    facet :legislation_subarea, type: :terms, size: LegislationSubarea.count
    facet :natures,             type: :terms, size: DecreeNature.count
    facet :form,                type: :terms
    facet :court_type,          type: :terms
    facet :court,               type: :terms
    facet :date,                type: :date,  interval: :month
    facet :legislations,        type: :terms
    facet :pages_count,         type: :range, ranges: [1..2, 2..5, 5..7,7..10,10..20]
    facet :file_number,         type: :terms
    facet :case_number,         type: :terms
  end

  def has_future_date?
    date > Time.now.to_date
  end

  def had_future_date?
    date > created_at.to_date
  end

  storage :resource, JusticeGovSk::Storage::DecreePage,     extension: :html
  storage :document, JusticeGovSk::Storage::DecreeDocument, extension: :pdf
  storage :image,    JusticeGovSk::Storage::DecreeImage,    extension: :pdf
end
