class ProceedingsController < ApplicationController
  def show
    @proceeding = Proceeding.find(params[:id])
    
    @hearings = @proceeding.hearings.order(:date)
    @decrees  = @proceeding.decrees.order(:date)

    @events = (@hearings + @decrees).sort { |a, b| a.date <=> b.date } 
  end
end
