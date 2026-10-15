# frozen_string_literal: true

module Probe
  # The facets of one search, built fresh from the model's facet definitions so that searches never share state. It
  # reads the facet params of a listing's URL, and turns them into the parts of a search:
  #
  # - queries: full text, scored (the `q` facet);
  # - filters: every other selected facet; values of one facet are ORed, facets are ANDed;
  # - aggregations: per facet, counted under the full text and the other facets' filters but not its own, so a facet
  #   keeps offering its other values after one is selected.
  class Facets
    include Enumerable

    MISSING = 'missing'

    attr_reader :params, :query_params

    def self.build(base, definitions)
      new(definitions.map { |type, name, field, options| create(type, name, field, options.merge(base:)) })
    end

    def self.create(type, name, field, options)
      "Probe::Facets::#{type.to_s.camelize}Facet".constantize.new(name, field, options)
    end

    def self.bool_filter(clauses)
      clauses.any? ? { bool: { filter: clauses } } : { match_all: {} }
    end

    def initialize(facets)
      @facets = facets.index_by { |facet| facet.name.to_s }
      @params = ActiveSupport::HashWithIndifferentAccess.new
      @query_params = ActiveSupport::HashWithIndifferentAccess.new
    end

    def extract_params(params)
      params.each do |param, value|
        facet = self[param]
        terms = facet&.parse_terms(value)

        next if terms.nil?

        facet.terms = terms
        @params[facet.name] = terms
      end

      each { |facet| facet.params = @params }
      add_search_params
    end

    def add_search_params(sort: nil, order: nil)
      @params[:sort] = sort if sort
      @params[:order] = order if order
      @query_params = @params.except(:page, :per_page, :order, :sort)

      self
    end

    def queries
      filter_map { |facet| facet.query if facet.respond_to?(:query) && facet.active? }
    end

    def filters(except: nil)
      filter_map do |facet|
        facet.filter if !facet.equal?(except) && facet.respond_to?(:filter) && facet.active?
      end
    end

    def aggregations
      select(&:buildable?).to_h do |facet|
        [facet.name, { filter: self.class.bool_filter(filters(except: facet)), aggs: facet.aggregation }]
      end
    end

    def populate(aggregations)
      select(&:buildable?).each { |facet| facet.populate(aggregations.fetch(facet.name.to_s, {})) }

      self
    end

    def highlights
      flat_map { |facet| facet.respond_to?(:highlights) ? Array.wrap(facet.highlights) : [] }
    end

    # The params a listing accepts: each facet, as one value or a list.
    def permitted_params
      flat_map { |facet| [facet.name, { facet.name => [] }] }
    end

    def each(&)
      @facets.each_value(&)
    end

    def [](name)
      @facets[name.to_s]
    end
  end
end
