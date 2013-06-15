class Proceeding < ActiveRecord::Base
  attr_accessible :file_number

  include Probe::Index
  include Probe::Search
  include Probe::Suggest

  has_many :hearings
  has_many :decrees

  mapping do
    map :id
    
    analyze :file_number
    analyze :courts,                         as: lambda { |p| p.courts.map(&:name) }
    analyze :courts_count,   type: :integer, as: lambda { |p| p.courts.count }
    analyze :judges,                         as: lambda { |p| p.judges.map(&:name) }
    analyze :judges_count,   type: :integer, as: lambda { |p| p.judges.count }
    analyze :events_count,   type: :integer, as: lambda { |p| p.events.count }
    analyze :hearings_count, type: :integer, as: lambda { |p| p.hearings.count }
    analyze :decrees_count,  type: :integer, as: lambda { |p| p.decrees.count }
  end

  facets do
    facet :q,              type: :fulltext, field: [:file_number, :judges, :courts]
    facet :courts,         type: :terms
    facet :judges,         type: :terms
    facet :decrees_count,  type: :range, ranges: [1..2, 2..5, 5..10]
    facet :hearings_count, type: :range, ranges: [1..5, 5..7, 7..15]
    facet :judges_count,   type: :range, ranges: [1..2, 2..5]
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
    # TODO rm
    #@proposers ||= hearings.flat_map(&:proposers).uniq(&:name).sort_by(&:name)
    
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
