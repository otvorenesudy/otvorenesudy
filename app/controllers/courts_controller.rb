class CourtsController < SearchController
  def show
    @court = Court.find(params[:id])

    @judges = @court.judges.order(:last, :middle, :first)

    @hearings = @court.hearings.order('date desc').limit(10)
    @decrees  = @court.decrees.order('date desc').limit(10)

    @hearings = @court.hearings.order('date desc')
    @decrees  = @court.decrees.order('date desc')

    @expenses = @court.expenses.order(:year)

    @results = @court.context_search[0..9]
  end

  def map
    @courts = Court::Map.courts
    @groups = Court::Map.groups
  end
end
