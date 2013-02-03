class SearchController < ApplicationController

  def autocomplete
    @models = %w(Judge)
    
    render json: {
      data: Judge.first(5).shuffle.map { |e| { value: e.name, facet: '20' } }
    }
  end

end
