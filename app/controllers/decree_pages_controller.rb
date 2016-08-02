class DecreePagesController < ApplicationController
  include ActionView::Helpers::TextHelper

  def search
    @decree = Decree.find(params[:decree_id])

    if params[:q].present?
      @results, @highlights = DecreePage.search_pages(@decree.id, params[:q])

      render json: { results: render_to_string(partial: 'results') }
    else
      render nothing: true
    end
  end

  def text
    @page = DecreePage.find_by_decree_id_and_number(params[:decree_id], params[:id])

    render text: simple_format(@page.text.strip)
  end

  # TODO rm?
  def image
    @page = DecreePage.find_by_decree_id_and_number(params[:decree_id], params[:id])

    path = File.join Rails.root, @page.image_path
    path = File.join Rails.root, 'app', 'assets', 'documents', 'unprocessed.png' unless File.exists? path

    send_file path, type: 'image/png', disposition: 'inline'
  end
end
