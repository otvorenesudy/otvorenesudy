# frozen_string_literal: true

class CourtsController < SearchController
  def show
    @court = Court.find(params.expect(:id))
    @judges = @court.judges.order(:last, :middle, :first)
    @expenses = @court.expenses.order(:year)
    @hearings = @court.hearings.order(date: :desc)
    @decrees = @court.decrees.order(date: :desc)
  end

  private

  def default_sort
    { sort: 'name', order: 'asc' }
  end
end
