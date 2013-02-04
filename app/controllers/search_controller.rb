class SearchController < ApplicationController

  def autocomplete
    @setup = { 
      :judges => :name
    }

    entity = params[:entity].to_sym
    term   = params[:term]

    if @setup.keys.include?(entity)
      model = entity.to_s.singularize.camelize.constantize  

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
