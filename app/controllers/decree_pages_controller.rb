class DecreePagesController < ApplicationController
  def text
    @page = DecreePage.find_by_decree_id_and_number(params[:decree_id], params[:id])

    # TODO: render error for nonexisting page?
    render text: @page ? @page.text : ''
  end

  def image
    @page = DecreePage.find_by_decree_id_and_number(params[:decree_id], params[:id])


    send_file File.join(Rails.root, @page.image_path), type: 'image/png', disposition: 'inline'
  end

  def search
    @results, @highlights = DecreePage.search_pages(params[:decree_id], params[:q])

    render json: {
      results: render_to_string(partial: 'results')
    }
  end

  private

end
