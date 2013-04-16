# encoding: utf-8

class DecreesController < ApplicationController
  def show
    @decree = Decree.find(params[:id])
    
    @court = @decree.court
    
    @legislations = @decree.legislations.order(:value)
    
    flash.now[:notice] = render_to_string(partial: 'date_notice').html_safe if @decree.had_future_date?
    flash.now[:error]  = render_to_string(partial: 'date_error').html_safe  if @decree.has_future_date?
  end
end
