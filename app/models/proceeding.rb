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
    analyze :decrees,       type: :integer, as: lambda { |p| p.decrees.count }
    analyze :hearings,      type: :integer, as: lambda { |p| p.hearings.count }
    analyze :judges,                        as: lambda { |p| p.judges.map(&:name) }
    analyze :judges_count,  type: :integer, as: lambda { |p| p.judges.count }
    analyze :courts,                        as: lambda { |p| p.courts.map(&:name) }
    analyze :courts_count,  type: :integer, as: lambda { |p| p.courts.count }
  end

  facets do
    facet :q,            type: :fulltext, field: [:file_number, :judges, :courts]
    facet :courts,       type: :terms
    facet :judges,       type: :terms
    facet :decrees,      type: :range, ranges: [1..2, 2..5, 5..10]
    facet :hearings,     type: :range, ranges: [1..5, 5..7, 7..15]
    facet :judges_count, type: :range, ranges: [1..2, 2..5]
  end

  def judges
    (hearings.map(&:judges).concat(decrees.map(&:judges))).flatten.uniq
  end

  def courts
    (hearings.map(&:court).concat(decrees.map(&:court))).flatten.uniq
  end
end
