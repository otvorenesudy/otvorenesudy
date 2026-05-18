class CourtsController < SearchController
  before_action :prepare_search_params, only: :index

  def show
    @court = Court.find(params[:id])

    @judges = @court.judges.order(:last, :middle, :first)
    @expenses = @court.expenses.order(:year)

    @hearings = @court.hearings.order('date desc')
    @decrees = @court.decrees.order('date desc')
  end

  private

  def index_params
    params.permit(:q, :page, :sort, :order, :per_page, :l, :facet, :term, type: [], municipality: [], hearings_count: [], decrees_count: [], judges_count: [], expenses: [])
  end

  def prepare_search_params
    params[:sort] = 'name' unless params[:sort].present?
    params[:order] = 'asc' if params[:sort] == 'name' && params[:order].blank?
  end
end
