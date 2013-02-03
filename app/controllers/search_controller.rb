class SearchController < ApplicationController

  def autocomplete
    @models = %w(Judge)
    
    # TODO: remove, test purpose
    render json: {
      data: Judge.first(5).shuffle.map { |e| { value: e.name, facet: '20' } }
    }
  end

end
