class SearchController < ApplicationController

  def autocomplete
    @whitelist = [:judges]

    entity = params[:entity].to_sym
    term   = params[:term]

    if @whitelist.include?(entity)
      render json: {
        data: Hearing.suggest(entity, term)   
      }
    else
      render status: 422,
      json: {
        error: "#{params[:entity]} is not valid autocomplete entity, damn!"
      }
    end
  end

  def search

  end

end
