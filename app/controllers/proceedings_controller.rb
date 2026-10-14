# frozen_string_literal: true

class ProceedingsController < SearchController
  def show
    @proceeding = Proceeding.find(params.expect(:id))

    @events = @proceeding.events
    @courts = @proceeding.courts.order(:name)
    @judges = @proceeding.judges.order(:last, :middle, :first)
    @hearings = @proceeding.hearings
    @decrees = @proceeding.decrees
  end
end
