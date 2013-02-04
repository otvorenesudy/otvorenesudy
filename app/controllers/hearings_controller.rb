class HearingsController < ApplicationController
  def index
    @hearings = Hearing.all
  end
  
  def show
    @hearing = Hearing.find(params[:id])
    
    @type  = @hearing.type
    @past  = @hearing.date.past?
    @court = @hearing.court
    
    @proposers  = @hearing.proposers.order(:name)
    @opponents  = @hearing.opponents.order(:name)
    @defendants = @hearing.defendants.order(:name)
  end
end
