# encoding: utf-8

module Probe::Search
  class Composer
    attr_accessor :results

    include Probe::Sanitizer
    include Probe::Helpers
    include Probe::Search::Query
    include Probe::Search::Filter

    def initialize(probe, params)
      @probe       = probe
      @base        = probe.base
      @name        = probe.name
      @facets      = probe.facets
      @sort_fields = probe.sort_by || []
      @per_page    = probe.per_page || Configuration.per_page
      @params      = params || {}

      @sort_fields += [:'_score'] unless @sort_fields.include? :'_score'

      @page     = extract_page_param(@params) if @params[:page]
      @order    = extract_order_param(@params) if @params[:order]
      @sort     = extract_sort_param(@params, @sort_fields) if @params[:sort]

      @facets.extract_facets_params(@params)
      @facets.add_search_params(sort: @sort, order: @order)
    end

    def compose(&block)
      index = Hash.new

      compose_search(index, &block)

      @results = Tire.search @name, @index

      Results.new(@probe, @results)
    end

    def compose_search(index, &block)
      @index = index

      if block_given?
        block.arity > 0 ? yield(@index, @facets, @params) : instance_eval(&block)
      else
        search_query
        search_filter
        search_facets
        search_sort
        search_highlights
        search_pagination
      end

      if Rails.env.development? && index.respond_to?(:to_hash)
        puts JSON.pretty_generate(index.to_hash)
      end

      @index
    end

    def compose_filtered_query
      @index ||= Hash.new

      @index.merge! build_filtered_query_from(@facets.build_query, @facets.build_filter(:and))
    end

    private

    def match_all
      @index.merge! build_match_all_query
    end

    def search_query
      queries = @facets.build_query

      @index.merge! query: { bool: queries } if queries
    end

    def search_filter
      filter = build_search_filter

      @index.merge! filter: filter if filter
    end

    def build_search_filter
      @facets.build_filter :and
    end

    def build_facet_filter(facet, options = {})
      queries = @facets.build_query
      filter  = @facets.build_facet_filter(:and, facet)

      build_filtered_query_from(queries, filter)
    end

    def search_facets
      facets = Hash.new

      @facets.each do |facet|
        next unless facet.buildable?

        options = Hash.new

        options[:global]       = true
        options[:facet_filter] = build_facet_filter(facet)

        facets.merge! facet.build(facet.name, options)
        facets.merge! facet.build(facet.selected_name, global: false) if facet.active?
      end

      @index.merge! facets: facets
    end

    def search_sort
      field ||= @sort_fields.first

      @index.merge! sort: [{ field => @order || :desc }]
    end

    def search_highlights
      fields = @facets.highlights.inject(Hash.new) { |hash, field| hash[field] = Hash.new }

      @index.merge! highlight: { fields: fields } if fields.any?
    end

    def search_pagination
      @page ||= 1

      @index.merge! size: @per_page
      @index.merge! from: @per_page * (@page - 1) if @page
    end
  end
end
