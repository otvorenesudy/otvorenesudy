class SearchController < ApplicationController
  def index
    set_search_model
    set_collapsed_facets
    set_subscription

    @results = @model.search(params.freeze)
    @results.associations = search_associations
    @facets = @results.facets
  end

  def suggest
    set_search_model

    name, term = params[:facet], params[:term]

    @results = @model.suggest(name, term, params.except(:facet, :term))

    if @results
      facet   = @results.facets[name]
      results = facet.results

      render partial: facet.view[:results] || "facets/#{facet.type}_results", locals: { facet: facet, visible: results.first(10), other: results[10..-1] || [] }
    else
      render nothing: true
    end
  end

  def collapse
    set_search_model
    set_collapsed_facets

    id = params[:facet]

    if @model.facets.find { |facet| facet.id == id }
      params[:collapsed] == 'true' ? @collapsed_facets.add(id) : @collapsed_facets.delete(id)
    end

    render nothing: true
  end

  private

  def set_search_model
    @model = params[:controller].singularize.camelize.constantize
  end

  def set_collapsed_facets
    @collapsed_facets = (session["#{params[:controller]}.collapsed_facets".to_sym] ||= Set.new)
  end

  def set_subscription
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

  def search_associations
    nil
  end

  helper_method :search_path, :suggest_path

  def search_path(params = {})
    url_for params.merge action: :index
  end

  def suggest_path(params = {})
    url_for params.merge action: :suggest
  end
end
