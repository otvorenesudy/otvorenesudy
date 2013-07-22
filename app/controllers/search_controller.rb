class SearchController < ApplicationController
  def search
    prepare

    @results = @model.search(params.freeze)

    @count       = @results.total_count
    @page        = @results.page
    @facets      = @results.facets
    @sort_fields = @results.sort_fields

    prepare_subscription

    prepare_facets
  end

  def suggest
    prepare

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

  helper_method :prepare,
                :prepare_facets,
                :prepare_collapsible_facets,
                :prepare_collapsed_facets,
                :prepare_subscription,
                :collapsed_facets_key,
                :search_path,
                :suggest_path

  def prepare
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

    session[session_key] ||= []

    @collapsed_facet_names = session[session_key]
  end

  def prepare_subscription
    if user_signed_in? && @model.respond_to?(:subscribe)
      query = Query.by_model_and_value(@model, @facets.query_params).first

      if query
        @subscription = Subscription.find_by_user_id_and_query_id(current_user.id, query.id)
      end

      unless @subscription
        @subscription = Subscription.new

        @subscription.query = query || Query.new
      end
    end
  end

  def collapsed_facets_key(model)
    "#{model.to_s.underscore}.collapsed_facet_names".to_sym
  end

  def search_path(params = {})
    "#{url_for(params.merge action: :search)}#search-navigation"
  end

  def suggest_path(params = {})
    url_for params.merge action: :suggest
  end
end
