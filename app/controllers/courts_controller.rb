class CourtsController < ApplicationController
  include CourtsHelper

  def index
    @constitutional = Court.by_type(CourtType.constitutional).first
    @highest        = Court.by_type(CourtType.highest).first
    @specialized    = Court.by_type(CourtType.specialized).first

    @regional = Court.by_type(CourtType.regional).order(:name)
    @district = Court.by_type(CourtType.district).order(:name)
  end

  def map
    @courts = Court.order(:name).all
    @groups = courts_group_by_coordinates(@courts)
  end

  def show
    @court = Court.find(params[:id])

    @judges   = @court.judges.order(:first, :middle, :last)
    @hearings = @court.hearings
    @decrees  = @court.decrees
  end
end
