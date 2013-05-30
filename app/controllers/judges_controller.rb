class JudgesController < ApplicationController
  def index
    @judges = Judge.order(:last, :middle, :first).page(params[:page])
  end

  def show
    @judge = Judge.find(params[:id])

    @employments  = @judge.employments
    @designations = @judge.designations.order('date desc')

    @past_hearings     = @judge.hearings.past.limit(10)
    @upcoming_hearings = @judge.hearings.upcoming.limit(10)
    @decrees           = @judge.decrees.limit(10)

    @related_persons = @judge.related_persons

    @search       = Bing::Search.new
    @search.query = @judge.to_context_query
    @results      = @search.perform
  end
end
