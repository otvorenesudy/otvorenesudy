# frozen_string_literal: true

# Ranks objects by a value, sharing a rank between ties: ranks 1, 2..3, 4 for values 9, 7, 7, 5. `rank_with_order`
# reads the rank from whichever end the object is closer to.
module Resource
  class Ranking
    def initialize(objects, &)
      @groups = objects.group_by(&)
      @total = objects.size
    end

    def ascending
      @ascending ||= Ordering.new(@groups.sort)
    end

    def descending
      @descending ||= Ordering.new(@groups.sort.reverse)
    end

    def rank_with_order(object)
      rank = descending[object]
      value = rank.is_a?(Range) ? (rank.min + rank.max) / 2.0 : rank

      return { rank:, order: :desc } if (@total / 2.0) - value >= 0

      { rank: ascending[object], order: :asc }
    end

    class Ordering
      def initialize(groups)
        @ranks = build_ranks(groups)
      end

      delegate :[], to: :@ranks

      def each(&)
        @ranks.each(&)
      end

      private

      def build_ranks(groups)
        rank = 0

        groups.each_with_object({}) do |(_, group), ranks|
          rank = rank.max if rank.is_a?(Range)
          rank = group.size == 1 ? rank + 1 : (rank + 1)..(rank + group.size)

          group.each { |object| ranks[object] = rank }
        end
      end
    end
  end
end
