class SearchController < ApplicationController
  def index
    search_instances

    @results = @model.search params.freeze

    @results.associations = search_associations

    @count       = @results.total_count
    @page        = @results.page
    @facets      = @results.facets
    @sort_fields = @results.sort_fields

    prepare_facets
    prepare_subscription
  end

  def suggest
    search_instances

    name = params[:facet]
    term = params[:term]

    @results = @model.suggest name, term, params.except(:facet, :term)

    if @results
      facet   = @results.facets[name]
      results = facet.results

      render partial: facet.view[:results] || "facets/#{facet.type}_facet_results", locals: { facet: facet, visible: results.first(10), other: results[10..-1] || [], options: {} }
    else
      render nothing: true
    end
  end

  def collapse
    model     = params[:model].to_s
    name      = params[:name].to_sym
    collapsed = params[:collapsed] == 'true' ? true : false

    if Probe::Configuration.indices.include? model.pluralize
      key = "#{model.to_s.underscore}.collapsed_facet_names".to_sym

      session[key] ||= []

      if collapsed
        session[key] += [name]
      else
        session[key] -= [name]
      end
    end

    render nothing: true
  end

  protected

  helper_method :search_instances,
                :prepare_facets,
                :prepare_subscription,
                :search_path,
                :suggest_path

  def search_instances
    @type  = params[:controller].singularize.to_sym
    @model = @type.to_s.camelcase.constantize
  end

  def prepare_facets
    @collapsible_facet_names = @facets.map(&:name) - [:q]

    key = "#{@model.to_s.underscore}.collapsed_facet_names".to_sym

    session[key] ||= []

    @collapsed_facet_names = session[key]
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

  def search_path(params = {})
    url_for params.merge action: :index
  end

  def suggest_path(params = {})
    url_for params.merge action: :suggest
  end

  private

  def search_associations
    nil
  end
end
