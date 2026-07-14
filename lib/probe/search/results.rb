module Probe::Search
  class Results
    include Enumerable
    include Probe::Helpers::Index

    attr_reader :model, :facets, :sort_fields, :response

    def initialize(model, facets, sort_fields, response, page, per_page)
      @model = model
      @facets = facets
      @sort_fields = sort_fields
      @response = response
      @page = page.to_i
      @per_page = per_page.to_i
      @hits = response['hits']['hits'] || []
      @total_entries = response.dig('hits', 'total', 'value') || 0
    end

    def records
      @records ||= fetch_records
    end

    def facets
      @populated_facets ||= populate_facets
    end

    def params
      @facets.params
    end

    def query_params
      @facets.query_params
    end

    def highlights
      @highlights ||= format_highlights
    end

    def offset
      @per_page * (@page - 1)
    end

    def current_page
      @page
    end

    def previous_page
      @page > 1 ? @page - 1 : nil
    end

    def next_page
      @page < total_pages ? @page + 1 : nil
    end

    def per_page
      @per_page
    end

    def total_pages
      return 1 if @per_page.zero?
      (@total_entries.to_f / @per_page).ceil
    end

    def total_entries
      @total_entries
    end

    def time
      @response['took']
    end

    alias model_name model
    alias limit_value per_page
    alias total_count total_entries
    alias num_pages total_pages
    alias offset_value offset
    alias page current_page

    def first_page?
      @page == 1
    end

    def last_page?
      @page >= total_pages
    end

    def empty?
      records.empty?
    end

    def associations=(associations)
      @associations = associations
      @records = nil
    end

    def each(&block)
      records.each_with_index do |record, i|
        yield(record, highlights[i])
      end
    end

    private

    def fetch_records
      ids = @hits.map { |hit| (hit.dig('_source', 'id') || hit['_id']).to_i }
      records = @model.where(id: ids)
      records = records.includes(@associations) if @associations
      records.sort_by! { |record| ids.index(record.id) }
      records
    end

    def populate_facets
      aggs = @response['aggregations'] || {}
      @facets.populate(aggs)
      @facets
    end

    def format_highlights
      @hits.map do |hit|
        highlight = {}
        @facets.highlights.each do |field|
          h_field = analyzed_field(field).to_s
          highlight[field] = hit.dig('highlight', h_field) || []
        end
        highlight
      end
    end
  end
end
