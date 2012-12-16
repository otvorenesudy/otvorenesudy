# encoding: utf-8

class CourtsController < ApplicationController
  def index
    @constitutional = Court.by_type('Ústavný')
    @high           = Court.by_type('Najvyšší')
    @special        = Court.by_type('Špeciálny')

    @regional = Court.by_type('Krajský').order(:name)
    @district = Court.by_type('Okresný').order(:name)
  end
end
