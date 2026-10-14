# frozen_string_literal: true

# A case followed through its hearings and decrees, across courts.
class Proceeding < ApplicationRecord
  include Probe

  has_many :hearings, dependent: nil
  has_many :decrees, dependent: nil

  before_save :invalidate_caches

  max_paginates_per 100
  paginates_per 20

  mapping do
    map :id

    analyze :case_numbers, as: lambda(&:case_numbers)
    analyze :file_number
    analyze :eclis, as: lambda(&:eclis)
    analyze :text, as: lambda(&:text), index: :no
    analyze :courts, as: ->(proceeding) { proceeding.courts.map(&:name) }
    analyze :courts_types, as: ->(proceeding) { proceeding.courts.map { |court| court.type&.value } }
    analyze :courts_count, type: :integer, as: ->(proceeding) { proceeding.courts.count }
    analyze :judges, as: ->(proceeding) { proceeding.judges.map(&:name) }
    analyze :judges_count, type: :integer, as: ->(proceeding) { proceeding.judges.count }
    analyze :events_count, type: :integer, as: ->(proceeding) { proceeding.events.count }
    analyze :hearings_count, type: :integer, as: ->(proceeding) { proceeding.hearings.count }
    analyze :decrees_count, type: :integer, as: ->(proceeding) { proceeding.decrees.count }

    analyze :duration, type: :integer, as: ->(proceeding) { proceeding.duration&./(1.month) }
    analyze :closed, type: :boolean, as: lambda(&:probably_closed?)

    analyze :proposers, as: ->(proceeding) { proceeding.proposers.map(&:name) }
    analyze :opponents, as: ->(proceeding) { proceeding.opponents.map(&:name) }
    analyze :defendants, as: ->(proceeding) { proceeding.defendants.map(&:name) }
    analyze :participants, as: ->(proceeding) { proceeding.opponents.map(&:name) + proceeding.defendants.map(&:name) }

    sort_by :_score, :hearings_count, :decrees_count
  end

  facets do
    facet :q, type: :fulltext, field: :all, highlights: :text
    facet :case_numbers, type: :terms
    facet :courts, type: :terms
    facet :judges, type: :terms
    facet :duration, type: :range, ranges: [1..3, 3..6, 6..12, 12..24]
    facet :hearings_count, type: :range, ranges: [1..1, 2..2, 3..5, 5..10]
    facet :decrees_count, type: :range, ranges: [1..1, 2..2, 3..5, 5..10]
    facet :courts_count, type: :range, ranges: [1..1, 2..2, 3..5, 5..10]
    facet :judges_count, type: :range, ranges: [1..1, 2..2, 3..5, 5..10]
    facet :courts_types, type: :terms
    facet :file_number, type: :terms
    # Off (the default) shows every proceeding, on only those that probably ended with a decree.
    facet :closed, type: :boolean, facet: :terms, default: false, value: ->(facet) { true if facet.terms == true }
  end

  def case_numbers
    @case_numbers ||= events.filter_map(&:case_number).uniq.sort
  end

  def eclis
    decrees.pluck(:ecli).compact.sort
  end

  def text
    decrees.map(&:text).join("\n") if decrees.any?
  end

  # Hearings and decrees in the order they happened.
  def events
    @events ||= (hearings.to_a + decrees.to_a).sort_by { |event| event.time || event.created_at }
  end

  def courts
    Court.where(id: events.map(&:court_id).uniq)
  end

  def judges
    Judge.where(id: Judging.where(hearing: hearings).select(:judge_id))
         .or(Judge.where(id: Judgement.where(decree: decrees).select(:judge_id)))
  end

  def judges_exact
    Judge.where(id: Judging.exact.where(hearing: hearings).select(:judge_id))
         .or(Judge.where(id: Judgement.exact.where(decree: decrees).select(:judge_id)))
  end

  def judges_inexact
    Judge.where(id: Judging.inexact.where(hearing: hearings).select(:judge_id))
         .or(Judge.where(id: Judgement.inexact.where(decree: decrees).select(:judge_id)))
  end

  def legislation_areas_and_subareas
    @legislation_areas_and_subareas ||=
      decrees.order(:date).map(&:legislation_areas_and_subareas).find(&:any?) || []
  end

  def proposers
    parties(Proposer)
  end

  def opponents
    parties(Opponent)
  end

  def defendants
    parties(Defendant)
  end

  # Seconds from the first event with a time to the last one if the proceeding probably ended, else to `time`.
  def duration(time = Time.current)
    first, last = duration_events

    return unless first&.time
    return last.time.to_i - first.time.to_i if probably_closed?

    time.to_i - first.time.to_i
  end

  def duration_events
    @duration_events ||= [events.find(&:time), events.rfind(&:time)]
  end

  def single_hearing?
    events.size == 1 && hearings.size == 1
  end

  def single_decree?
    events.size == 1 && decrees.size == 1
  end

  def probably_closed?
    events.last.is_a?(Decree)
  end

  def invalidate_caches
    @case_numbers = @duration_events = @events = @legislation_areas_and_subareas = nil
  end

  private

  def parties(model)
    model.select(:name).distinct.joins(:hearing).where(hearings: { proceeding_id: id })
  end
end
