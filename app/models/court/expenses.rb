module Court::Expenses
  extend self

  @courts  = {}
  @ranking = {}

  def courts(type)
    @courts[type] ||= Court.by_type(type).select { |court| court.expenses.any? }
  end

  def rank(court)
    ranking(court.type).descending[court]
  end

  def rank_with_order(court)
    ranking(court.type).rank_with_order(court)
  end

  private

  def ranking(type)
    @ranking[type] ||= Resource::Ranking.new(courts(type)) { |court| court.expenses_total }
  end
end
