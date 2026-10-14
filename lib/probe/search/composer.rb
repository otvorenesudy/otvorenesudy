# frozen_string_literal: true

module Probe
  module Search
    # Builds and runs one search: full text in the query, facet filters as a post filter so each facet's aggregation
    # can leave its own filter out, then sorting, highlights and the page.
    class Composer
      attr_reader :model, :facets, :sort_fields, :page, :per_page

      def initialize(model, params)
        @model = model
        @params = params.to_h.with_indifferent_access
        @facets = model.facets.extract_params(@params.except(:page, :sort, :order, :per_page))
        @sort_fields = model.sort_fields | [:_score]
        @per_page = model.per_page
        @page = Probe::Sanitizer.page(@params[:page], max: max_page)
        @sort = Probe::Sanitizer.sort(@params[:sort], @sort_fields) if @params[:sort]
        @order = Probe::Sanitizer.order(@params[:order]) if @params[:order]

        @facets.add_search_params(sort: @sort, order: @order)
      end

      def compose
        response = search(body)

        Probe::Search::Results.new(model, facets, response, page:, per_page:)
      end

      def body(escape: :syntax)
        filters = facets.filters

        {
          query: query(escape:),
          post_filter: (Probe::Facets.bool_filter(filters) if filters.any?),
          aggs: facets.aggregations,
          sort:,
          highlight:,
          from: per_page * (page - 1),
          size: per_page,
          track_total_hits: true,
          _source: false
        }.compact
      end

      private

      # Elasticsearch rejects some queries people type (a lone AND); those are searched again as plain words.
      def search(body)
        model.client.search(index: model.index_name, body:)
      rescue Elastic::Transport::Transport::Errors::BadRequest
        raise unless facets.queries.any?

        model.client.search(index: model.index_name, body: self.body(escape: :all))
      end

      def query(escape:)
        queries = facets.select { |facet| facet.respond_to?(:query) && facet.active? }.map { |f| f.query(escape:) }

        { bool: { must: queries.presence || [{ match_all: {} }] } }
      end

      def sort
        field = @sort || sort_fields.first
        name = field == :_score ? '_score' : Probe::Fields.keyword(field)

        [{ name => { order: @order || :desc } }]
      end

      def highlight
        fields = facets.highlights

        return if fields.empty?

        options = { number_of_fragments: 1_000_000 }

        { fields: fields.to_h { |field| [Probe::Fields.analyzed(field), options] }, max_analyzed_offset: 999_999 }
      end

      # Elasticsearch returns at most 10,000 results to page through.
      def max_page
        [10_000 / model.per_page, 1].max
      end
    end
  end
end
