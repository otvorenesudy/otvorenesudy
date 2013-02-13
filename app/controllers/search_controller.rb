class SearchController < ApplicationController

  def autocomplete
    @entity = params[:entity].to_sym
    @term   = params[:term]

    if [:judges, :court].include?(@entity)
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
    
    @query[:facets]  = [:judges, :court]
    @query[:options] = { global_facets: true }
    
    @search, @results = @model.search_by(@query)
    
    @type  = @model.name.downcase.to_sym
    @count = @results.total_count
    @page  = @search[:results]
    
    render json: {
      facets:     @search[:facets],
      info:       render_to_string(partial: 'info'),
      results:    render_to_string(partial: 'results'),
      pagination: render_to_string(partial: 'pagination')
    }
  end
    
  private 

  def parse_search_query(params)
    params ||= Hash.new

    model = Hearing
    query = Hash.new

    query[:filter] = Hash.new
    
    params.symbolize_keys.each do |key, value|

      case key
      when :page
        query[:page] = value.first if value.is_a?(Array)
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
