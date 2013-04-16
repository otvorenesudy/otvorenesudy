class JudgesController < ApplicationController
  def index
    @judges = Judge.order(:last, :middle, :first).page(params[:page])
  end

  def show
    @judge = Judge.find(params[:id])

    @employments = @judge.employments
    @hearings    = @judge.hearings.limit(10)
    @decrees     = @judge.decrees.limit(10)
  end
end
