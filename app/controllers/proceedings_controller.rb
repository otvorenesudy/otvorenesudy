class ProceedingsController < ApplicationController
  def show
    @proceeding = Proceeding.find(params[:id])
    
    @events = @proceeding.events
  end
end
