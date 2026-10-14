# frozen_string_literal: true

class Hearing < ApplicationRecord
  include Resource::URI
  include Resource::Subscribable

  include Probe

  include Judge::Matched

  scope :at_court, ->(court) { where(court_id: court) }

  scope :during_employment, lambda { |employment|
    where(court_id: employment.court).joins(:judgings).merge(Judging.of_judge(employment.judge))
  }

  scope :historical, -> { where(date: ...Time.current) }
  scope :upcoming, -> { where(date: Time.current..) }

  belongs_to :proceeding, optional: true
  belongs_to :court, optional: true
  belongs_to :original_court, class_name: 'Court', optional: true

  has_many :judgings, dependent: :destroy
  has_many :inexact_judgings, -> { inexact }, class_name: 'Judging', inverse_of: :hearing, dependent: nil

  has_many :judges, through: :judgings
  has_many :exact_judges,
           -> { where(judgings: { judge_name_similarity: 1.0 }).order(:last, :middle, :first) },
           through: :judgings,
           source: :judge

  belongs_to :type, class_name: 'HearingType', foreign_key: :hearing_type_id, optional: true, inverse_of: :hearings
  belongs_to :section, class_name: 'HearingSection', foreign_key: :hearing_section_id, optional: true, inverse_of: false
  belongs_to :subject, class_name: 'HearingSubject', foreign_key: :hearing_subject_id, optional: true, inverse_of: false
  belongs_to :form, class_name: 'HearingForm', foreign_key: :hearing_form_id, optional: true, inverse_of: false

  has_many :proposers, dependent: :destroy
  has_many :opponents, dependent: :destroy
  has_many :defendants, dependent: :destroy

  has_many :accusations, through: :defendants

  before_save :invalidate_caches

  max_paginates_per 100
  paginates_per 20

  mapping do
    map :id

    analyze :case_number
    analyze :file_number
    analyze :date, type: :date
    analyze :room
    analyze :special_type
    analyze :commencement_date, type: :date
    analyze :type, as: ->(hearing) { hearing.type&.value }
    analyze :court, as: ->(hearing) { hearing.court&.name }
    analyze :court_type, as: ->(hearing) { hearing.court&.type&.value }
    analyze :judges, as: lambda(&:judge_names)
    analyze :form, as: ->(hearing) { hearing.form&.value }
    analyze :section, as: ->(hearing) { hearing.section&.value }
    analyze :subject, as: ->(hearing) { hearing.subject&.value }
    analyze :proposers, as: ->(hearing) { hearing.proposers.pluck(:name) }
    analyze :opponents, as: ->(hearing) { hearing.opponents.pluck(:name) }
    analyze :defendants, as: ->(hearing) { hearing.defendants.pluck(:name) }
    analyze :participants, as: ->(hearing) { hearing.opponents.pluck(:name) + hearing.defendants.pluck(:name) }
    analyze :accusations, as: lambda { |hearing|
      hearing.accusations.map { |accusation|
        "#{accusation.value} #{accusation.paragraphs.pluck(:description).join(' ')}"
      }
    }

    sort_by :date, :created_at
  end

  facets do
    facet :q, type: :fulltext, field: :all
    facet :type, type: :terms, collapsible: false
    facet :court_type, type: :terms
    facet :court, type: :terms
    facet :subject, type: :terms
    facet :judges, type: :terms
    facet :date, type: :date, interval: :month
    facet :form, type: :terms
    facet :proposers, type: :terms
    facet :participants, type: :terms
    facet :section, type: :terms
    facet :file_number, type: :terms
    facet :case_number, type: :terms
    # Off (historical=false) keeps the hearings from now on.
    facet :historical,
          type: :boolean,
          field: :date,
          facet: :date,
          value: ->(facet) { [Time.current..Time.zone.parse('2038-01-19')] if facet.terms == false }
    facet :exact_date, type: :abstract, field: :date, facet: :date, interval: :month
  end

  def time
    @time ||= date&.to_datetime
  end

  def judge_names
    @judge_names ||= Judge::Names.of(judges)
  end

  def historical?
    date&.past?
  end

  alias historical historical?

  def future_date?
    date - 2.years > Time.current unless date.nil?
  end

  def future_date_when_created?
    date - 2.years > created_at unless date.nil?
  end

  def unprocessed?
    court.nil? || judgings.none?
  end

  def anonymized?
    anonymized_at.present?
  end

  def social_security_case?
    names = [defendants, opponents, proposers].flat_map do |association|
      association.loaded? ? association.map(&:name) : association.pluck(:name)
    end

    names.any? { |name| ActiveSupport::Inflector.transliterate(name).downcase.match?(/socialna\s+poistovna/) }
  end

  # Replaces the parties' names with random initials, unique within each kind of party.
  def anonymize!(parties = %i[proposers opponents defendants])
    HearingAnonymizer.new(self).anonymize!(parties)
  end

  def self.anonymize!
    find_each(&:anonymize!)

    Judge.find_each(&:save!)
    Court.find_each(&:save!)
  end

  def self.anonymize_anonymizable_hearings!
    where(anonymized_at: nil).anonymize!
  end

  def invalidate_caches
    @time = @judge_names = nil
  end
end
