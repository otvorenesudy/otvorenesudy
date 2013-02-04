class DecreesController < ApplicationController
  def index
    @decrees = Decree.all
  end
  
  def show
    @decree = Decree.find(params[:id])
    
    @court = @decree.court
    
    @legislations = @decree.legislations
  end
end
