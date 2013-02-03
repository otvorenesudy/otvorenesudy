class JudgesController < ApplicationController
  def index
    @judges = Judge.order(:first, :middle, :last).page(params[:page])
  end
  
  def show
    @judge = Judge.find(params[:id])
    
    @employments = @judge.employments
    @hearings    = @judge.hearings
    @decrees     = @judge.decrees
  end
end
