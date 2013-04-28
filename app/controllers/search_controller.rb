class SearchController < ApplicationController
  include ActionView::Helpers::NumberHelper

  def suggest
    @entity = params[:entity].to_sym
    @term   = params[:term]

    @model, @query = parse_search_query

    if @model && @model.has_facet?(@entity)
      render json: {
        data: @model.suggest(@entity, @term, @query)
      }
    else
      render status: 422,
      json: {
        error: "#{params[:entity]} is not valid suggestable entity!"
      }
    end
  end

  def search
    @model, @query = parse_search_query

    if @model && @query
      @query[:options] ||= Hash.new

      @query[:options].merge! global_facets: true

      @search, @results = @model.search_by(@query)

      @type       = @model.name.downcase.to_sym
      @count      = @results.total_count
      @page       = @search[:results]
      @highlights = @search[:highlights]

      render json: {
        facets:     format_facets(@search[:facets]),
        info:       render_to_string(partial: 'info'),
        results:    render_to_string(partial: 'results'),
        pagination: render_to_string(partial: 'pagination')
      }

    else
      render json: {
        error: 'Invalid query.',
        html:  render_to_string(partial: 'error')
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
    query[:query]  = Hash.new

    begin
      raise unless models.include?(params[:type].to_sym)

      model = params[:type].camelize.constantize

      data = params[:data] || Hash.new

      data.symbolize_keys.each do |key, value|
        next unless model.has_facet?(key) || [:page, :per_page, :q, :sort, :sort_order].include?(key)

        case key
        when :page
          query[:page] = value.first
        when :date
          dates = data[key].map { |e| e.split('..') }

          dates.map! { |e| Time.at(e[0].to_i)..Time.at(e[1].to_i) }

          query[:filter].merge!(date: dates)
        when :historical
          if value[0] == 'false'
            dates = [Time.now..Time.parse('2038-01-19')]

            query[:filter].merge!(historical: dates)
          end
        when :q
          query[:query].merge!(text: data[key].first)
        else
          query[:filter].merge!(key => data[key])
        end

      end

      return model, query

    rescue Exception => e
      raise e
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
