class DecreesController < SearchController
  include FileHelper

  def show
    @decree = Decree.find(params[:id])

    @court  = @decree.court
    @judges = @decree.judges.order(:name)

    @legislations = @decree.legislations.order(:value)

    flash.now[:error]  = render_to_string(partial: 'has_future_date', locals: { decree: @decree}).html_safe if @decree.has_future_date?
    flash.now[:notice] = render_to_string(partial: 'had_future_date', locals: { decree: @decree}).html_safe if @decree.had_future_date?
  end

  def resource
    @decree = Decree.find(params[:id])

    send_file_in @decree.resource_path, type: 'text/plain'
  end

  def document
    @decree = Decree.find(params[:id])

    send_file_in @decree.document_path, name: "rozhodnutie-#{@decree.ecli}"
  end
end
