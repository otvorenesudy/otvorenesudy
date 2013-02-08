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
        error: "#{params[:entity]} is not valid autocomplete entity!"
      }
    end
  end

  def search
    @model, @query = parse_search_query
    
    @query[:facets] = [:judges]
    
    result = @model.search_by(@query)
    
    render json: {
      data: result[:results],
      facets: result[:facets]
    }
  end
    
  private 

  def parse_search_query

    model = Hearing
    query = Hash.new
    
    params.each do |key, value|
      
      case key
      when :category
        # TODO: Parse category
      when :judges
        query[:filter].merge! judges: params[key] if params[key].is_a?(Array)
      end

    end

    return model, query
  end

end
