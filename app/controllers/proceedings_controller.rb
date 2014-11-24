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
end
