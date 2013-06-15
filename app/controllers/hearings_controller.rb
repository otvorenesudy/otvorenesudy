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
  end

  def resource
    @hearing = Hearing.find(params[:id])

    send_file_in @hearing.resource_path, type: 'text/plain'
  end
end
