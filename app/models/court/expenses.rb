# frozen_string_literal: true

# Courts of one type ranked by their total expenses (court expenses 2010-2013 in data/).
class Court
  module Expenses
    module_function

    def courts(type)
      Court.by_type(type).where(id: CourtExpense.select(:court_id))
    end

    def rank(court)
      ranking(court.type).descending[court.id]
    end

    def rank_with_order(court)
      ranking(court.type).rank_with_order(court.id)
    end

    def ranking(type)
      totals = CourtExpense.joins(:court).where(courts: { court_type_id: type.id }).group(:court_id).sum(:value)

      Resource::Ranking.new(totals.keys) { |id| totals[id] }
    end
  end
end
