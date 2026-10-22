# frozen_string_literal: true

module Probe
  module Search
    # A page of results: the records in the order Elasticsearch ranked them, each with its highlights, the populated
    # facets, and Kaminari's pagination interface (`paginate @results`).
    class Results
      include Enumerable

      attr_reader :model, :response, :per_page, :current_page, :associations

      alias limit_value per_page
      alias page current_page

      def initialize(model, facets, response, page:, per_page:)
        @model = model
        @search_facets = facets
        @response = response
        @current_page = page
        @per_page = per_page
      end

      def each
        records.each_with_index { |record, index| yield record, highlights[index] }
      end

      def records
        @records ||= fetch_records
      end

      def associations=(associations)
        @associations = associations
        @records = nil
      end

      def facets
        @facets ||= @search_facets.populate(response['aggregations'] || {})
      end

      delegate :params, to: :@search_facets

      delegate :query_params, to: :@search_facets

      def highlights
        @highlights ||= hits.map do |hit|
          @search_facets.highlights.index_with { |field| hit.dig('highlight', Probe::Fields.analyzed(field)) || [] }
        end
      end

      def total_count
        response.dig('hits', 'total', 'value').to_i
      end

      alias total_entries total_count

      # Pages beyond Elasticsearch's 10,000 results aren't offered.
      def total_pages
        [(total_count.to_f / per_page).ceil, 10_000 / per_page].min
      end

      alias num_pages total_pages

      def offset_value
        per_page * (current_page - 1)
      end

      alias offset offset_value

      def first_page?
        current_page == 1
      end

      def last_page?
        current_page >= total_pages
      end

      def previous_page
        current_page - 1 unless first_page?
      end

      alias prev_page previous_page

      def next_page
        current_page + 1 unless last_page?
      end

      def out_of_range?
        current_page > total_pages
      end

      delegate :empty?, to: :records

      def time
        response['took']
      end

      private

      def hits
        response.dig('hits', 'hits').to_a
      end

      def fetch_records
        ids = hits.map { |hit| hit['_id'].to_i }
        scope = model.where(id: ids)
        scope = scope.includes(associations) if associations

        scope.index_by(&:id).values_at(*ids).compact
      end
    end
  end
end
