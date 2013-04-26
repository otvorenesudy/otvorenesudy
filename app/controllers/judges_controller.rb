class JudgesController < ApplicationController
  def index
    @judges = Judge.order(:last, :middle, :first).page(params[:page])
  end

  def show
    @judge = Judge.find(params[:id])

    @employments          = @judge.employments
    @past_hearings        = @judge.hearings.past.limit(10)
    @upcoming_hearings    = @judge.hearings.upcoming.limit(10)
    @decrees              = @judge.decrees.limit(10)
  end
end
