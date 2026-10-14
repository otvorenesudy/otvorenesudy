# frozen_string_literal: true

# Faceted listings: courts, judges, hearings, decrees and proceedings inherit `index` (results, facets and
# subscription) and `suggest` (one facet's values matching what the visitor types). `collapse` remembers which facets
# a visitor folded.
class SearchController < ApplicationController
  helper_method :search_path, :suggest_path

  before_action :apply_default_sort, only: :index

  def index
    @model = model
    @type = model.model_name.element.to_sym
    @results = model.search(search_params)
    @results.associations = search_associations
    @count = @results.total_count
    @page = @results.page
    @facets = @results.facets
    @sort_fields = model.sort_fields | [:_score]

    prepare_facets
    prepare_subscription
  end

  def suggest
    facets = model.suggest(params[:facet], params[:term], search_params)

    return head :ok unless facets

    facet = facets[params[:facet]]
    results = facet.results

    render partial: suggest_partial(facet), locals: { facet:, visible: results.first(10), other: results[10..] || [] }
  end

  def collapse
    model = Probe.models.find { |candidate| candidate.model_name.element == params[:model].to_s }
    name = params[:facet].to_s

    return head :unprocessable_content unless model&.facets&.[](name)

    key = "#{model.model_name.element}.collapsed_facets"
    collapsed = Array(session[key])
    session[key] = params[:collapsed] == 'true' ? collapsed | [name] : collapsed - [name]

    head :no_content
  end

  protected

  def search_path(params = {})
    url_for(params.to_h.symbolize_keys.merge(controller: controller_name, action: :index))
  end

  def suggest_path(params = {})
    url_for(params.to_h.symbolize_keys.merge(controller: controller_name, action: :suggest))
  end

  private

  def suggest_partial(facet)
    facet.view[:results] || "facets/#{facet.type}_results"
  end

  def model
    controller_name.classify.constantize
  end

  # The listing's facets, each as one value or a list, with the page and sorting.
  def search_params
    params.permit(:page, :sort, :order, *model.facets.permitted_params).to_h
  end

  def search_associations
    nil
  end

  # A listing's own sorting when the visitor picks none: { sort: 'name', order: 'asc' }. The order applies only with
  # that sort; other sorts default to descending.
  def default_sort
    nil
  end

  # A missing or unknown sort falls back to the default one, in its default order unless the order is given.
  def apply_default_sort
    return unless default_sort

    params[:sort] = default_sort[:sort] unless (model.sort_fields | [:_score]).map(&:to_s).include?(params[:sort])
    params[:order] = default_sort[:order] if params[:sort] == default_sort[:sort] && params[:order].blank?
  end

  def prepare_facets
    @collapsible_facets = @facets.map(&:name) - [:q]
    @collapsed_facets = Array(session["#{@type}.collapsed_facets"]).map(&:to_sym)
  end

  def prepare_subscription
    return unless user_signed_in? && @model.respond_to?(:subscribe)

    query = Query.by_model_and_value(@model, @facets.query_params).first
    subscription = Subscription.find_by(user: current_user, query:) if query

    @subscription = subscription || Subscription.new(query: query || Query.new)
  end
end
