module Document
  module Searchable
    extend ActiveSupport::Concern

    included do
      extend Document::Search::Query
      extend Document::Search::Filter
      extend Document::Search::Facet
      extend Document::Search::Results
    end

    module ClassMethods

      def search_by(params = {})
        format_result(*compose_search(params))
      end

      private

      def compose_search(params)
        page         = params[:page]         || 1
        per_page     = params[:per_page]     || 20
        terms        = params[:filter]       || Hash.new
        facets       = params[:facets]       || @facets
        options      = params[:options]      || {}
        sort         = params[:sort]
        order        = params[:order]

        options[:global_facets] ||= false

        prepare(terms, facets)

        results = tire.search page: page, per_page: per_page do |index|
          if block_given?
            yield index, facets, sort, order, options
          else
            search_query(index, facets, options)
            search_filter(index, facets, options)
            search_facets(index, facets, options)
            search_sort(index, sort, order, options)
          end

          puts JSON.pretty_generate(index.to_hash) # TODO: debug, rm
        end

        return facets, results
      end

      def prepare(terms, facets)
        facets.each do |_, facet|
          facet.refresh!
        end

        terms.each do |name, values|
          facets[name].terms = values
        end
      end

      def search_query(index, facets, options)
        if facets.any?
          queries = []

          facets.each do |_, facet|
            if facet.respond_to?(:build_query) && facet.terms.present?
              queries << facet.build_query
            end
          end

          if queries.any?
            index.query do |query|
              query.boolean do |boolean|
                queries.each { |q| boolean.must(&q) }
              end
            end
          end
        end
      end

      def search_filter(index, facets, options)
        type, filters = build_search_filter(facets)

        index.filter type, filters if type && filters.any?
      end

      def search_facets(index, facets, options)
        if facets.any?
          facets.each do |name, facet|
            next if facet.abstract?

            facet_options = Hash.new

            facet_options[:global]       = options[:global_facets]
            facet_options[:facet_filter] = build_facet_filter(facets.except(name))
            facet_options[:size]         = facet.size

            build_facet(index, name, facet.field, facet, facet_options)

            if facet.terms.any?
              facet_options[:global]       = false
              facet_options[:facet_filter] = build_facet_filter(facets)
              facet_options[:size]         = facet.terms.size

              build_facet(index, selected_facet_name(name), facet.field, facet, facet_options)
            end
          end
        end
      end

      def search_sort(index, sort, order, options)
        field = sort == :_score ? :_score : not_analyzed_field(sort)

        if sort
          index.sort { by field, order || 'desc' }
        end
      end

      def search_highlights(index, query, highlights, options)
        options = highlights.map { |e| analyzed_field(e) }

        index.highlight(*options)
      end

      private

      def build_search_filter(facets)
        filter = build_filter_from(:or, facets)

        return :and, filter if filter.any?
      end

      def build_facet_filter(facets)
        type, filters = build_search_filter(facets)

        { type => filters } if type && filters
      end
    end
  end
end
