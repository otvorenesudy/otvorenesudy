# encoding: utf-8

class Hearing < ActiveRecord::Base
  include Resource::URI
  include Resource::Storage
  include Resource::Subscribable

  include Probe

  include Judge::Matched

  attr_accessible :case_number,
                  :file_number,
                  :date,
                  :room,
                  :special_type,
                  :commencement_date,
                  :selfjudge,
                  :note

  scope :at_court, lambda { |court| where court_id: court }

  scope :during_employment, lambda { |employment| where(court_id: employment.court).joins(:judgings).merge(Judging.of_judge(employment.judge)) }

  scope :historical, lambda { where('date <  ?', Time.now) }
  scope :upcoming,   lambda { where('date >= ?', Time.now) }

  belongs_to :proceeding

  belongs_to :court

  has_many :judgings, dependent: :destroy

  has_many :judges, through: :judgings

  belongs_to :type,    class_name: :HearingType,    foreign_key: :hearing_type_id
  belongs_to :section, class_name: :HearingSection, foreign_key: :hearing_section_id
  belongs_to :subject, class_name: :HearingSubject, foreign_key: :hearing_subject_id
  belongs_to :form,    class_name: :HearingForm,    foreign_key: :hearing_form_id

  has_many :proposers,  dependent: :destroy
  has_many :opponents,  dependent: :destroy
  has_many :defendants, dependent: :destroy

  has_many :accusations, through: :defendants

  max_paginates_per 100
      paginates_per 20

  mapping do
    map :id

    analyze :case_number
    analyze :file_number
    analyze :date,              type: :date
    analyze :room
    analyze :special_type
    analyze :commencement_date, type: :date
    analyze :type,              as: lambda { |h| h.type.value if h.type }
    analyze :court,             as: lambda { |h| h.court.name if h.court }
    analyze :court_type,        as: lambda { |h| h.court.type.value if h.court }
    analyze :judges,            as: lambda { |h| h.judge_names }
    analyze :form,              as: lambda { |h| h.form.value if h.form }
    analyze :section,           as: lambda { |h| h.section.value if h.section }
    analyze :subject,           as: lambda { |h| h.subject.value if h.subject }
    analyze :proposers,         as: lambda { |h| h.proposers.pluck(:name) }
    analyze :opponents,         as: lambda { |h| h.opponents.pluck(:name) }
    analyze :defendants,        as: lambda { |h| h.defendants.pluck(:name) }
    analyze :participants,      as: lambda { |h| h.opponents.pluck(:name) + h.defendants.pluck(:name) }
    analyze :accusations,       as: lambda { |h| h.accusations.map { |a| "#{a.value} #{a.paragraphs.pluck(:description).join ' '}" } }

    sort_by :date, :created_at
  end

  facets do
    facet :q,            type: :fulltext, field: :all
    facet :type,         type: :terms, collapsible: false
    facet :court_type,   type: :terms
    facet :court,        type: :terms
    facet :subject,      type: :terms
    facet :judges,       type: :terms
    facet :date,         type: :date, interval: :month
    facet :form,         type: :terms
    facet :proposers,    type: :terms
    facet :participants, type: :terms
    facet :section,      type: :terms
    facet :file_number,  type: :terms
    facet :case_number,  type: :terms
    facet :historical,   type: :boolean, field: :date, facet: :date, value: lambda { |facet| [Time.now..Time.parse('2038-01-19')] if facet.terms == false }
    facet :exact_date,   type: :abstract, field: :date, facet: :date, interval: :month
  end

  def judge_names
    @judge_names ||= Judge::Names.of judges
  end

  def historical
    date.past? unless date.nil?
  end

  alias :historical? :historical

  def has_future_date?
    date - 2.years > Time.now.to_datetime unless date.nil?
  end

  def had_future_date?
    date - 2.years > created_at unless date.nil?
  end

  def unprocessed?
    court.nil? || judgings.none?
  end

  before_save :invalidate_caches

  def invalidate_caches
    @judge_names = nil
  end

  storage :resource, JusticeGovSk::Storage::HearingPage, extension: :html do |hearing|
    File.join hearing.type.name.to_s, JusticeGovSk::URL.url_to_path(hearing.uri, :html)
  end
end
