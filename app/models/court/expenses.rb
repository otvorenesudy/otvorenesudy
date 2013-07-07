module Court::Expenses
  extend self

  def courts
    @courts ||= Court.where('court_type_id != ?', CourtType.constitutional).select { |court| court.expenses.any? }
  end

  def rank(court)
    ranking.descending[court]
  end

  private

  def ranking
    @ranking ||= Resource::Ranking.new(courts) { |court| court.expenses_total }
  end
end
