class SearchController < ApplicationController
  include ActionView::Helpers::NumberHelper

  def suggest
    @entity = params[:entity].to_sym
    @term   = params[:term]

    @model, @query = parse_search_query

    if @model && @model.has_facet?(@entity)
      render json: {
        data: format_facet(@model.suggest(@entity, @term, @query))
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
    models = Document::Configuration.models

    query          = Hash.new
    query[:filter] = Hash.new
    query[:query]  = Hash.new

    begin
      raise unless models.include?(params[:_type].to_sym)

      model = params[:_type].camelize.constantize
      data  = params[:data] || Hash.new

      data.symbolize_keys.each do |key, value|
        next unless model.has_facet?(key) || [:page, :per_page, :q, :sort, :order].include?(key)

        case key
        when :page
          query[:page] = value
        when :sort
          query[:sort] = value.to_sym
        when :order
          query[:order] = value.to_sym
        else
          facet = model.facets[key]

          query[:filter].merge!(key => facet.parse(value))
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
      format_facet(values)
    end
  end

  def format_facet(values)
    values.each do |facet|
      facet[:count] = number_with_delimiter(facet[:count])
      facet[:label] = facet[:title] = facet[:label].gsub(/\d+/) { |m| number_with_delimiter(m.to_i) }

      facet[:label] = "#{facet[:label].first(30)}..." if facet[:label].length > 30
    end
  end
end
