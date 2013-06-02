class HearingsController < ApplicationController
  include FileHelper
  
  def show
    @hearing = Hearing.find(params[:id])
    
    @type  = @hearing.type
    @past  = @hearing.date.past?
    @court = @hearing.court
    
    @proposers  = @hearing.proposers.order(:name)
    @opponents  = @hearing.opponents.order(:name)
    @defendants = @hearing.defendants.order(:name)
  end
  
  def resource
    @hearing = Hearing.find(params[:id])
    
    send_file_in @hearing.resource_path
  end
end
