class Proceeding < ActiveRecord::Base
  attr_accessible :file_number

  include Probe

  has_many :hearings
  has_many :decrees

  max_paginates_per 100
      paginates_per 20

  mapping do
    map :id

    analyze :case_numbers,                   as: lambda { |p| p.case_numbers }
    analyze :file_number
    analyze :eclis,                          as: lambda { |p| p.eclis }
    analyze :text,                           as: lambda { |p| p.text }
    analyze :courts,                         as: lambda { |p| p.courts.map(&:name) }
    analyze :courts_types,                   as: lambda { |p| p.courts.map { |c| c.type.value } }
    analyze :courts_count,   type: :integer, as: lambda { |p| p.courts.count }
    analyze :judges,                         as: lambda { |p| p.judges.map(&:name) }
    analyze :judges_count,   type: :integer, as: lambda { |p| p.judges.count }
    analyze :events_count,   type: :integer, as: lambda { |p| p.events.count }
    analyze :hearings_count, type: :integer, as: lambda { |p| p.hearings.count }
    analyze :decrees_count,  type: :integer, as: lambda { |p| p.decrees.count }

    analyze :duration,       type: :integer, as: lambda { |p| p.duration / 1.month if p.duration }
    analyze :closed,         type: :boolean, as: lambda { |p| p.probably_closed? }

    analyze :proposers,                      as: lambda { |p| p.proposers.pluck(:name) }
    analyze :opponents,                      as: lambda { |p| p.opponents.pluck(:name) }
    analyze :defendants,                     as: lambda { |p| p.defendants.pluck(:name) }
    analyze :participants,                   as: lambda { |p| p.opponents.pluck(:name) + p.defendants.pluck(:name) }

    sort_by :_score, :hearings_count, :decrees_count
  end

  facets do
    facet :q,              type: :fulltext, field: :all, highlights: :text
    facet :case_numbers,   type: :terms
    facet :courts,         type: :terms
    facet :judges,         type: :terms
    facet :duration,       type: :range, ranges: [1..3, 3..6, 6..12, 12..24]
    facet :hearings_count, type: :range, ranges: [1..1, 2..2, 3..5, 6..10]
    facet :decrees_count,  type: :range, ranges: [1..1, 2..2, 3..5, 6..10]
    facet :courts_count,   type: :range, ranges: [1..1, 2..2, 3..5, 6..10]
    facet :judges_count,   type: :range, ranges: [1..1, 2..2, 3..5, 6..10]
    facet :courts_types,   type: :terms
    facet :file_number,    type: :terms
    #facet :proposers,      type: :terms
    #facet :participants,   type: :terms
    facet :closed,         type: :boolean, facet: :terms, default: false, value: lambda { |facet| true if facet.terms == true }
  end

  def case_numbers
    @case_numbers ||= events.map(&:case_number).uniq.sort
  end

  def eclis
    decrees.pluck(:ecli).sort
  end

  def text
    decrees.map(&:text).join("\n") if decrees.any?
  end

  def events
    @events ||= (hearings + decrees).sort_by { |event| event.time ? event.time : event.created_at }
  end

  def courts
    Court.where(id: @court_ids ||= events.map(&:court_id).uniq)
  end

  # TODO judges* refactor into AR relations if possible

  def judges
    judges = events.flat_map { |event| block_given? ? yield(event) : event.judges }.uniq
    judges.define_singleton_method(:order) { |*attributes| Array.wrap(attributes).each { |attribute| self.sort_by { |e| value = e.send(attribute) ? value : value.to_s }  }; self }
    judges.define_singleton_method(:pluck) { |attribute| self.map { |judge| judge.read_attribute(attribute.to_s.sub(/\Ajudge_/, '')) }}
    judges
  end

  def judges_exact
    judges { |event| event.judges.exact }
  end

  def judges_inexact
    judges { |event| event.judges.inexact }
  end

  def legislation_area_and_subarea
    @legislation_area_and_subarea ||= decrees.order(:date).each_with_object([]) do |decree, _|
      break decree.legislation_area_and_subarea if decree.legislation_area_and_subarea.any?
    end
  end

  def proposers
    through_hearings_to Proposer
  end

  def opponents
    through_hearings_to Opponent
  end

  def defendants
    through_hearings_to Defendant
  end

  def duration(time = Time.now)
    return duration_events.last.time.to_i - duration_events.first.time.to_i if probably_closed?

    # TODO this is probably a bug as we are storing Time.now based result to ES but not updating it:
    # we store proceeding with duration 4 months and then no event occurs in 4 months, status:
    # ES has it indexed under 4 months duration but on show it renders 8 months
    # TODO resolve
    time.to_i - duration_events.first.time.to_i if duration_events.first.try(:time)
  end

  def duration_events
    @duration_events ||= [events.find { |event| event.time }, events.reverse.find { |event| event.time }]
  end

  private

  def through_hearings_to(model)
    model.select('distinct name').joins(:hearing).where(:'hearings.proceeding_id' => id)
  end

  public

  def single_hearing?
    events.size == 1 && hearings.size == 1
  end

  def single_decree?
    events.size == 1 && decrees.size == 1
  end

  def probably_closed?
    events.last.is_a? Decree
  end

  before_save :invalidate_caches

  def invalidate_caches
    @case_numbers = @duration_events = @events = @court_ids = @legislation_area_and_subarea = nil
  end
end
