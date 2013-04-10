class SearchController < ApplicationController
  include ActionView::Helpers::NumberHelper

  def autocomplete
    @entity = params[:entity].to_sym
    @term   = params[:term]

    if [:judges, :court].include?(@entity)
      @model, @query = parse_search_query

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
    @model, @query = parse_search_query

    if @model && @query

      @query[:options] = { global_facets: true }

      @search, @results = @model.search_by(@query)

      @type  = @model.name.downcase.to_sym
      @count = @results.total_count
      @page  = @search[:results]

      render json: {
        facets:     format_facets(@search[:facets]),
        info:       render_to_string(partial: 'info'),
        results:    render_to_string(partial: 'results'),
        pagination: render_to_string(partial: 'pagination')
      }

    else
      render status: 422, json: {
        error: 'Not a valid query.'
      }
    end
  end

  private

  helper_method :parse_search_query,
                :format_facets

  def parse_search_query
    models = [:hearing, :decree]

    query          = Hash.new
    query[:filter] = Hash.new

    begin

      raise unless models.include?(params[:type].to_sym)

      model = params[:type].camelize.constantize

      data = params[:data] || Hash.new

      data.symbolize_keys.each do |key, value|

        case key
        when :page
          query[:page] = value.first
        when :judges
          query[:filter].merge!(judges: data[key])
        when :court
          query[:filter].merge!(court: data[key])
        when :date
          times = data[key][0].split('..').map { |e| Time.parse(e) }

          query[:filter].merge!(date: times[0]..times[1])
        end

      end

      return model, query

    rescue Exception => e
      puts e.message

      nil
    end

  end

  def format_facets(facets)
    # TODO: use better way to formatting facets count and etc?
    facets.each do |key, values|
      values.each do |facet|
        facet[:count] = number_with_delimiter(facet[:count])
      end
    end
  end

end
