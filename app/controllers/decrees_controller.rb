class DecreesController < ApplicationController
  def show
    @decree = Decree.find(params[:id])
    
    @court = @decree.court
    
    @legislations = @decree.legislations.order(:value)
    
    flash.now[:notice] = render_to_string(partial: 'has_future_date_notice').html_safe if @decree.had_future_date?
    flash.now[:error]  = render_to_string(partial: 'had_future_date_error').html_safe  if @decree.has_future_date?
  end
  
  def document
    @decree = Decree.find(params[:id])
    
    name = "rozhodnutie-#{@decree.ecli.gsub(/\W/, '-')}.pdf"
    
    send_file File.join(Rails.root, @decree.document_path), type: 'application/pdf', filename: name, disposition: 'inline'
  end
end
