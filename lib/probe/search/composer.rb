module Probe::Search
  class Composer
    include Probe::Sanitizer
    include Probe::Helpers::Index
    include Probe::Search::Query
    include Probe::Search::Filter

    def initialize(model, options)
      @model = model
      @name = options[:name]
      @facets = options[:facets]
      @params = options[:params] || {}
      @sort_fields = options[:sort_fields] || []
      @fields = Array.wrap(options[:fields]) + [:id]

      @sort_fields += [:_score] unless @sort_fields.include?(:_score)

      @page = extract_page_param(@params) if @params[:page]
      @order = extract_order_param(@params) if @params[:order]
      @sort = extract_sort_param(@params, @sort_fields) if @params[:sort]
      @per_page = options[:per_page] || Probe::Configuration.per_page

      @facets.extract_facets_params(@params)
      @facets.add_search_params(sort: @sort, order: @order)
    end

    def compose
      body = build_body
      response = Probe.client.search(index: @name, body: body)
      Results.new(@model, @facets, @sort_fields, response, @page || 1, @per_page)
    end

    def compose_filtered_query
      build_bool_query
    end

    private

    def build_body
      body = {}
      body[:query] = build_bool_query
      body[:aggs] = build_aggregations
      body[:sort] = build_sort
      body[:size] = @per_page
      body[:from] = @per_page * ((@page || 1) - 1)

      highlights = build_highlights
      body[:highlight] = highlights if highlights

      body[:_source] = (@fields + [@sort]).compact.uniq.map(&:to_s)
      body
    end

    def build_bool_query
      must_clauses = @facets.build_query.compact
      filter_clauses = @facets.build_filter_clauses.compact

      bool = {}
      bool[:must] = must_clauses if must_clauses.any?
      bool[:filter] = filter_clauses if filter_clauses.any?

      bool.any? ? { bool: bool } : { match_all: {} }
    end

    def build_aggregations
      aggs = {}

      @facets.each do |facet|
        next unless facet.buildable?

        filter_body = build_facet_filter_for(facet)
        aggs[facet.name.to_s] = facet.build_aggregation(filter_body)

        if facet.active?
          selected_filter_body = build_facet_filter_for(nil)
          aggs[facet.selected_name.to_s] = facet.build_aggregation(selected_filter_body)
        end
      end

      aggs
    end

    def build_facet_filter_for(exclude_facet)
      filter_clauses = @facets.build_selective_filter_clauses(exclude: exclude_facet).compact
      query_clauses = @facets.build_query_filter.compact

      all_clauses = (filter_clauses + query_clauses).compact
      return nil if all_clauses.empty?

      { bool: { filter: all_clauses } }
    end

    def build_sort
      @sort ||= @sort_fields.first
      field = @sort == :_score ? '_score' : not_analyzed_field(@sort).to_s
      [{ field => { order: (@order || :desc).to_s } }]
    end

    def build_highlights
      fields = @facets.highlights
      return nil if fields.empty?

      highlight_fields = fields.each_with_object({}) do |f, h|
        h[analyzed_field(f).to_s] = { number_of_fragments: 1_000_000 }
      end
      { fields: highlight_fields }
    end
  end
end
