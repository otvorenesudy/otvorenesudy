# encoding: utf-8

class CourtsController < ApplicationController
  include CourtsHelper
  
  # TODO refactor, use CourtType.constant instead of strings
  def index
    @constitutional = Court.by_type('Ústavný').first
    @highest        = Court.by_type('Najvyšší').first
    @specialized    = Court.by_type('Špecializovaný').first

    @regional = Court.by_type('Krajský').order(:name)
    @district = Court.by_type('Okresný').order(:name)
  end
  
  def map
    @courts = Court.order(:name).all
    @groups = courts_group_by_coordinates(@courts)
  end
  
  def show
    @court = Court.find(params[:id])
    
    @judges   = @court.judges
    @hearings = @court.hearings
    @decrees  = @court.decrees
  end
end
