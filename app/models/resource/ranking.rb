class Resource::Ranking
  def initialize(objects, &block)
    @groups = build_groups objects, &block
    @total  = objects.size
  end

  def ascending
    @ascending ||= Ordering.new(@groups) { |groups| groups.sort }
  end

  def descending
    @descending ||= Ordering.new(@groups) { |groups| groups.sort.reverse }
  end
  
  def rank_with_order(object)
    rank  = descending[object]
    value = rank.is_a?(Range) ? (rank.min + rank.max) / 2.0 : rank
    
    return { rank: rank, order: :desc } if (@total / 2.0) - value >= 0
    
    { rank: ascending[object], order: :asc }
  end

  class Ordering
    def initialize(groups)
      @ranks = build_ranks Hash[yield groups]
    end
    
    def [] object
      @ranks[object]
    end
    
    def each(&block)
      @ranks.each(&block)
    end

    private

    def build_ranks(groups)
      ranks, rank = Hash.new, 0
      
      groups.each do |key, group|
        rank = rank.max if rank.is_a? Range
        rank = group.size == 1 ? rank + 1 : (rank + 1) .. (rank + group.size)
        
        group.each { |o| ranks[o] = rank }
      end
      
      ranks
    end
  end

  private
  
  def build_groups(objects)
    groups = Hash.new

    objects.each do |o|
      key = yield o
      
      groups[key] ||= []
      groups[key] << o
    end

    groups
  end
end
