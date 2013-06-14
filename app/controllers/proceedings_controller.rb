class ProceedingsController < SearchController
  def show
    @proceeding = Proceeding.find(params[:id])
    
    @events   = @proceeding.events
    @hearings = @proceeding.hearings
    @decrees  = @proceeding.decrees
  end
end
