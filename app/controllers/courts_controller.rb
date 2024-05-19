class CourtsController < SearchController
  before_filter :prepare_search_params, only: :index

  def show
    @court = Court.find(params[:id])

    @judges = @court.judges.order(:last, :middle, :first)
    @expenses = @court.expenses.order(:year)

    @hearings = @court.hearings.order('date desc')
    @decrees = @court.decrees.order('date desc')
  end

  private

  def prepare_search_params
    params[:sort] = 'name' unless params[:sort].present?
    params[:order] = 'asc' if params[:sort] == 'name' && params[:order].blank?
  end
end
