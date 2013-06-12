class SearchController < ApplicationController
  def search
    prepare_search

    @results = @model.search_by(params.freeze)

    @count       = @results.total_count
    @page        = @results.page
    @facets      = @results.facets
    @sort_fields = @results.sort_fields
  end

  def suggest
    prepare_search

    name = params[:name]
    term = params[:term]

    @results = @model.suggest(name, term, params)

    render(partial: "facets/facet_results", locals: { facet: @results.facets[name] })
  end

  protected

  helper_method :search_type,
                :search_path,
                :suggest_path

  def prepare_search
    @type  = params[:controller].singularize.to_sym
    @model = @type.to_s.camelcase.constantize
  end

  def search_path(params = {})
    url_for(params.merge action: :search)
  end

  def suggest_path(params = {})
    url_for(params.merge action: :suggest)
  end
end
