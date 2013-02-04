class SearchController < ApplicationController

  def autocomplete
    @setup = { 
      'judges' => :name
    }

    entity = params[:entity]
    term   = params[:term]

    if @setup.keys.include?(entity)
      model = entity.singularize.camelcase.constantize  

      render json: {
        data: model.suggest(@setup[entity], term)   
      }
    else
      render status: 422,
      json: {
        error: "#{params[:entity]} is not valid autocomplete entity."
      }
    end
  end

end
