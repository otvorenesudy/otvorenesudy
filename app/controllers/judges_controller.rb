class JudgesController < ApplicationController
  def index
    # TODO enable judges from other sources as well
    @judges = Judge.where(source_id: Source.find_by_module(:JusticeGovSk).id).order(:last, :middle, :first).page(params[:page])
  end

  def show
    @judge = Judge.find(params[:id])

    @employments       = @judge.employments
    @past_hearings     = @judge.hearings.past.limit(10)
    @upcoming_hearings = @judge.hearings.upcoming.limit(10)
    @decrees           = @judge.decrees.limit(10)
    @designations      = @judge.designations.order('date desc')

    @search       = Bing::Search.new
    @search.query = @judge.context_query
    @results      = @search.perform
  end
end
