class HearingsController < SearchController
  include FileHelper

  def show
    @hearing = Hearing.find(params[:id])

    @type   = @hearing.type
    @court  = @hearing.court
    @judges = @hearing.judges.order(:name)

    @proposers  = @hearing.proposers.order(:name)
    @opponents  = @hearing.opponents.order(:name)
    @defendants = @hearing.defendants.order(:name)
    
    flash.now[:error]  = render_to_string(partial: 'has_future_date', locals: { hearing: @hearing }).html_safe if @hearing.has_future_date?
    flash.now[:notice] = render_to_string(partial: 'had_future_date', locals: { hearing: @hearing }).html_safe if @hearing.had_future_date?
  end

  def resource
    @hearing = Hearing.find(params[:id])

    send_file_in @hearing.resource_path, type: 'text/plain'
  end
end
