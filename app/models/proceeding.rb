class Proceeding < ActiveRecord::Base
  attr_accessible :file_number

  include Probe

  has_many :hearings
  has_many :decrees

  max_paginates_per 100
      paginates_per 25

  mapping do
    map :id

    analyze :case_numbers,                   as: lambda { |p| p.case_numbers }
    analyze :file_number
    analyze :courts,                         as: lambda { |p| p.courts.map(&:name) if p.courts }
    analyze :courts_count,   type: :integer, as: lambda { |p| p.courts.count }
    analyze :judges,                         as: lambda { |p| p.judges.map(&:name) if p.judges }
    analyze :judges_count,   type: :integer, as: lambda { |p| p.judges.count }
    analyze :events_count,   type: :integer, as: lambda { |p| p.events.count }
    analyze :hearings_count, type: :integer, as: lambda { |p| p.hearings.count }
    analyze :decrees_count,  type: :integer, as: lambda { |p| p.decrees.count }

    sort_by :_score, :hearings_count, :decrees_count
  end

  facets do
    facet :q,              type: :fulltext, field: [:case_numbers, :file_number, :judges, :courts]
    facet :courts,         type: :terms
    facet :judges,         type: :terms
    facet :file_number,    type: :terms
    facet :case_numbers,   type: :terms
    facet :decrees_count,  type: :range, ranges: [1..2, 2..5, 5..10]
    facet :hearings_count, type: :range, ranges: [1..5, 5..7, 7..15]
    facet :judges_count,   type: :range, ranges: [1..2, 2..5]
  end

  def case_numbers
    @case_numbers ||= events.map(&:case_number).uniq
  end

  def events
    @events ||= (hearings + decrees).sort_by(&:date)
  end

  def courts
    Court.where(id: @court_ids ||= events.map(&:court_id).uniq)
  end

  def judges
    # TODO refactor into AR relation

    return @judges if @judges

    @judges = events.flat_map(&:judges).uniq
    @judges.define_singleton_method(:order) { |attribute| self.sort_by!(&attribute) }
    @judges
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

  private

  def through_hearings_to(model)
    model.select('distinct name').joins(:hearing).where(:'hearings.proceeding_id' => id)
  end

  public

  def single_hearing?
    events.count == 1 && hearings.count == 1
  end

  def single_decree?
    events.count == 1 && decrees.count == 1
  end

  def probably_closed?
    events.last.is_a? Decree
  end
end
