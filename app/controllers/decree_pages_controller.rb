class DecreePagesController < ApplicationController
  def text
    @page = DecreePage.find_by_decree_id_and_number(params[:decree_id], params[:id])

    render text: @page.text.gsub("\n", '<br/>')
  end

  def image
    @page = DecreePage.find_by_decree_id_and_number(params[:decree_id], params[:id])

    path = File.join(Rails.root, @page.image_path)
    path = 'public/assets/documents/unprocessed.png' unless File.exists? path

    send_file path, type: 'image/png', disposition: 'inline'
  end

  def search
    @decree = Decree.find(params[:decree_id])

    @results, @highlights = DecreePage.search_pages(@decree.id, params[:q])

    render json: { results: render_to_string(partial: 'results') }
  end
end
