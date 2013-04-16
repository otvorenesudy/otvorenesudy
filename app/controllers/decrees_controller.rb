# encoding: utf-8

class DecreesController < ApplicationController
  def show
    @decree = Decree.find(params[:id])
    
    @court = @decree.court
    
    @legislations = @decree.legislations.order(:value)
    
    flash[:error]  = render_to_string(partial: 'date_error').html_safe  if @decree.date > Time.now.to_date
    flash[:notice] = render_to_string(partial: 'date_notice').html_safe if @decree.date > @decree.created_at.to_date
  end
end
