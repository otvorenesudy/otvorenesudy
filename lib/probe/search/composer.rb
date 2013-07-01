module Probe::Search
  class Composer
    attr_accessor :results

    include Probe::Sanitizer
    include Probe::Helpers::Index
    include Probe::Search::Query
    include Probe::Search::Filter

    def initialize(model, options)
      @model            = model
      @name             = options[:name]
      @facets           = options[:facets]
      @params           = options[:params]
      @sort_fields      = options[:sort_fields]

      @sort_fields += [:'_score'] unless @sort_fields.include? :'_score'

      @page     = extract_page_param(@params) if @params[:page]
      @order    = extract_order_param(@params) if @params[:order]
      @sort     = extract_sort_param(@params, @sort_fields) if @params[:sort]
      @per_page = options[:per_page] || Probe::Configuration.per_page

      @facets.extract_facets_params(@params)
      @facets.add_search_params(sort: @sort, order: @order)
    end

    def compose(&block)
      @results = Tire.search @name do |index|
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

        puts JSON.pretty_generate(index.to_hash) # TODO: rm
      end

      Results.new(@model, @facets, @sort_fields, @results)
    end

    private

    def search_query
      queries = @facets.build_query

      if queries.any?
        @index.query do |query|
          query.boolean do |boolean|
            queries.each { |q| boolean.must(&q) }
          end
        end
      end
    end

    def build_search_filter
      filter = @facets.build_filter :and

      filter if filter[:and].any?
    end

    def build_facet_filter(facet)
      filter = @facets.build_selective_filter :and, exclude: [facet]

      filter if filter[:and].any?
    end

    def search_filter
      filter = build_search_filter

      @index.filter(*filter.first) if filter
    end

    def search_facets
      @facets.each do |facet|
        next unless facet.buildable?

        options                 = Hash.new
        options[:global_facets] = true
        options[:facet_filter]  = build_facet_filter(facet)

        facet.build(@index, facet.name, options)

        if facet.active?
          options                 = Hash.new
          options[:global_facets] = false
          options[:facet_filter]  = build_search_filter

          facet.build(@index, facet.selected_name, options)
        end
      end
    end

    def search_sort
      @sort ||= @sort_fields.first

      field = @sort == :'_score' ? @sort : not_analyzed_field(@sort)

      @index.sort { |s| s.by field, @order || :desc }
    end

    def search_highlights
      fields = @facets.highlights

      @index.highlight(*fields.map { |f| analyzed_field(f) }) if fields.any?
    end

    def search_pagination
      @page ||= 1

      @index.size(@per_page)
      @index.from(@per_page * (@page - 1)) if @page
    end
  end
end
