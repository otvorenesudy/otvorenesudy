class CourtsController < SearchController
  include CourtsHelper

  def index
    @constitutional = Court.by_type(CourtType.constitutional).first
    @supreme        = Court.by_type(CourtType.supreme).first
    @specialized    = Court.by_type(CourtType.specialized).first

    @regional = Court.by_type(CourtType.regional).order(:name)
    @district = Court.by_type(CourtType.district).order(:name)
  end

  def map
    @courts = Court::Map.courts
    @groups = Court::Map.groups
  end

  def show
    @court = Court.find(params[:id])

    @judges = @court.judges.order(:last, :middle, :first)

    @hearings = @court.hearings.order('date desc').limit(10)
    @decrees  = @court.decrees.order('date desc').limit(10)

    @hearings = Hearing.search court: @court.name, sort: :date
    @decrees  = Decree.search  court: @court.name, sort: :date

    @expenses = @court.expenses.order(:year)

    @results = @court.context_search[0..9]
  end
end
