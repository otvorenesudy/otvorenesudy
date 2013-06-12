module Probe::Search
  class Results
    include Enumerable

    attr_reader :records,
                :facets,
                :highlights,
                :sort_fields,
                :response,
                :results,
                :offset,
                :current_page,
                :previous_page,
                :next_page,
                :per_page,
                :total_pages,
                :total_entries

    def initialize(model, facets, sort_fields, response)
      @model       = model
      @facets      = facets
      @response    = response
      @sort_fields = sort_fields

      @results  = @response.results
    end

    def records
      @records ||= fetch_records
    end

    def facets
      @populated_facets ||= populate_facets
    end

    def highlights
      @highlights ||= format_highlights
    end

    def offset
      @offset ||= @results.offset
    end

    def current_page
      @current_page ||= @results.current_page
    end

    def previous_page
      @previous_page ||= @results.previous_page
    end

    def next_page
      @next_page ||= @results.next_page
    end

    def per_page
      @per_page ||= @results.per_page
    end

    def total_pages
      @total_pages ||= @results.total_pages
    end

    def total_entries
      @total_entries ||= @results.total_entries
    end

    # TODO: Kaminari suport
    alias :limit_value  :per_page
    alias :total_count  :total_entries
    alias :num_pages    :total_pages
    alias :offset_value :offset
    alias :page         :current_page

    def each(&block)
      records.each_with_index do |record, i|
        yield(record, highlights[i])
      end
    end

    private

    def fetch_records
      @results.map do |result|
        @model.find(result.id)
      end
    end

    def populate_facets
      @facets.populate(@results.facets)

      @facets
    end

    def format_highlights
      @results.map do |result|
        highlight = Hash.new

        @facets.highlights.each do |facet|
          field = facet.field

          field = [field] unless field.respond_to? :each

          field.each do |f|
            highlight[f] = result.highlight ? result.highlight[facet.analyzed_field_name] : []
          end
        end

        highlight
      end
    end
  end
end
