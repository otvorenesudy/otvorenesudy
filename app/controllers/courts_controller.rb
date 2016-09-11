class CourtsController < SearchController
  def show
    @court = Court.find(params[:id])

    @judges = @court.judges.order(:last, :middle, :first)
    @expenses = @court.expenses.order(:year)

    @hearings = @court.hearings.order('date desc')
    @decrees  = @court.decrees.order('date desc')

    @media = @court.context_search[0..9]
  end

  def map
    @courts = Court.order(:name).all
  end
end
