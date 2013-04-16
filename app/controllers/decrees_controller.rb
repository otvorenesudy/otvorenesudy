class DecreesController < ApplicationController
  def show
    @decree = Decree.find(params[:id])
    
    @court = @decree.court
    
    @legislations = @decree.legislations.order(:value)
  end
end
