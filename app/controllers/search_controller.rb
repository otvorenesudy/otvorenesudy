class SearchController < ApplicationController

  def autocomplete
    @whitelist = [:judges, :court]

    @entity = params[:entity].to_sym
    @term   = params[:term]

    if @whitelist.include?(@entity)
      @model, @query = parse_search_query(params[:data])

      render json: {
        data: @model.suggest(@entity, @term, @query)
      }
    else
      render status: 422,
      json: {
        error: "#{params[:entity]} is not valid autocomplete entity!"
      }
    end
  end

  def search
    @model, @query = parse_search_query(params[:data])
    
    @query[:facets] = [:judges, :court]
    
    result, total_count = @model.search_by(@query)
    
    render json: {
      data: render_to_string(:partial => 'results', locals: { type: @model, values: result[:results], options: { total: total_count } }),
      facets: result[:facets]
    }
  end
    
  private 

  def parse_search_query(params)

    model = Hearing
    query = Hash.new

    query[:filter] = Hash.new
    
    params.symbolize_keys.each do |key, value|

      case key
      when :category
        # TODO: Parse category
      when :judges
        query[:filter].merge!(judges: params[key]) if params[key].is_a?(Array)
      when :court
        query[:filter].merge!(court: params[key]) if params[key].is_a?(Array)
      end

    end

    return model, query
  end

end
