class Indicator::Ranking
  def initialize(objects, &block)
    @groups = build_groups objects, &block
  end

  def ascending
    @ascending ||= Ordering.new(@groups) { |groups| groups.sort }
  end

  def descending
    @descending ||= Ordering.new(@groups) { |groups| groups.sort.reverse }
  end

  class Ordering
    def initialize(groups)
      @ranks = build_ranks Hash[yield groups]
    end
    
    def [] object
      @ranks[object]
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
