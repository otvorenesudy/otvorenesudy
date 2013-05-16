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

    @search       = Bing::Search.new
    @search.query = "#{@judge.employments.first.court.name} \"#{@judge.first} #{@judge.middle} #{@judge.last}\" -site:judikaty.info -site:rozsudkyodetoch.sk -site:najpravo.sk -site:striedavastarostlivost.sk -site:prezident.sk -site:justice.gov.sk -site:justice.gov.sk -site:wwwold.justice.sk -site:sudnarada.gov.sk -site:paragraf.sk"
    @results      = @search.perform
  end
end
