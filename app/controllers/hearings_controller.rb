class HearingsController < ApplicationController
  def index
    @hearings = Hearing.all
  end
  
  def show
    @hearing = Hearing.find(params[:id])
  end
end
