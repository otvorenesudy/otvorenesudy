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
    @courts = Court.order(:name).all
    @groups = courts_group_by_coordinates(@courts)
  end

  def show
    @court = Court.find(params[:id])

    @judges = @court.judges.order(:last, :middle, :first)

    @expenses = @court.expenses.order(:year)

    @past_hearings     = @court.hearings.past.limit(10)
    @upcoming_hearings = @court.hearings.upcoming.limit(10)
    @decrees           = @court.decrees.limit(10)

    @search       = Bing::Search.new
    @search.query = @court.to_context_query
    @results      = @search.perform[0..10]
  end
end
