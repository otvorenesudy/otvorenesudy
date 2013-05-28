class JudgesController < ApplicationController
  def index
    # TODO enable judges from other sources as well
    @judges = Judge.where(source_id: Source.find_by_module(:JusticeGovSk).id).order(:last, :middle, :first).page(params[:page])
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
    @search.query = @judge.context_query
    @results      = @search.perform
  end
end
