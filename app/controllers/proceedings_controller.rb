class ProceedingsController < SearchController
  def show
    @proceeding = Proceeding.find(params[:id])

    @events   = @proceeding.events
    @courts   = @proceeding.courts.order(:name)
    @judges   = @proceeding.judges.order(:last, :middle, :first)
    @hearings = @proceeding.hearings
    @decrees  = @proceeding.decrees

    @proposers  = @proceeding.proposers.order(:name)
    @opponents  = @proceeding.opponents.order(:name)
    @defendants = @proceeding.defendants.order(:name)
  end

  private

  def index_params
    params.permit(
      :q, :page, :sort, :order, :per_page, :l, :closed, :facet, :term,
      case_numbers: [], courts: [], judges: [], duration: [], hearings_count: [],
      decrees_count: [], courts_count: [], judges_count: [], courts_types: [], file_number: []
    )
  end
end
