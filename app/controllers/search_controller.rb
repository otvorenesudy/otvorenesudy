class SearchController < ApplicationController
  def search
    prepare_search

    @results = @model.search_by(params.freeze)

    @count       = @results.total_count
    @page        = @results.page
    @facets      = @results.facets
    @sort_fields = @results.sort_fields

    prepare_facets
  end

  def suggest
    prepare_search

    name = params[:name]
    term = params[:term]

    @results = @model.suggest(name, term, params)

    facet   = @results.facets[name]
    results = facet.results

    render partial: "facets/#{facet.type}_facet_results", locals: { facet: facet, visible: results.first(10), other: results[10..-1] || [] }
  end

  def collapse
    model     = params[:model].to_s
    name      = params[:name].to_sym
    collapsed = params[:collapsed] == 'true' ? true : false

    if Probe::Configuration.indices.include? model.pluralize
      key = collapsed_facets_key(model)

      if collapsed
        session[key] += [name]
      else
        session[key] -= [name]
      end
    end

    render nothing: true
  end

  protected

  helper_method :prepare_search,
                :prepare_facets,
                :prepare_collapsible_facets,
                :prepare_collapsed_facets,
                :collapsed_facets_key,
                :search_path,
                :suggest_path

  def prepare_search
    @type  = params[:controller].singularize.to_sym
    @model = @type.to_s.camelcase.constantize
  end

  def prepare_facets
    prepare_collapsible_facets
    prepare_collapsed_facets
  end

  def prepare_collapsible_facets
    @collapsible_facet_names = @facets.map(&:name) - [:q]
  end

  def prepare_collapsed_facets
    session_key = collapsed_facets_key @model

    session[session_key] ||= @facets.map(&:name)[-2..-1]

    @collapsed_facet_names = session[session_key]
  end

  def collapsed_facets_key(model)
    "#{model.to_s.underscore}.collapsed_facet_names".to_sym
  end

  def search_path(params = {})
    url_for params.merge action: :search
  end

  def suggest_path(params = {})
    url_for params.merge action: :suggest
  end
end
