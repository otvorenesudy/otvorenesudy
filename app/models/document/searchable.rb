module Document
  module Searchable

    def self.included(base)
      base.extend(ClassMethods)

      base.extend(Document::Search::Query)
      base.extend(Document::Search::Filter)
      base.extend(Document::Search::Facet)
      base.extend(Document::Search::Results)
    end

    module ClassMethods

      def search_by(params = {})
        format_result(compose_search(params))
      end

      private

      def compose_search(params)
        @page       = params[:page]       || 1
        @per_page   = params[:per_page]   || 20
        @query      = params[:query]      || Hash.new
        @terms      = params[:filter]     || Hash.new
        @options    = params[:options]    || {}
        @sort_block = params[:sort]

        @options[:global_facets] ||= false

        results = tire.search page: @page, per_page: @per_page do |index|

          if block_given?

            yield index

          else

            search_query(index)
            search_filter(index)
            search_facets(index)
            search_sort(index)
            search_highlights(index)

          end

          puts JSON.pretty_generate(index.to_hash) # debug
        end

        results
      end

      private


      def search_query(index)
        if @query.any?

          index.query do |q|
            q.boolean do |bool|

              @query.each do |field, values|
                field = analyzed_field(field)

                values = prepare_query(values)

                bool.must {
                  string values,
                  default_field: field,
                  default_operator: :and,
                  analyze_wildcard: true
                }
              end

            end
          end
        end
      end

      def search_filter(index)
        if @query.any? || @terms.any?
          filters = []

          filters.concat build_filters(@terms) if @terms.any?
          filters.concat build_query(@query)   if @query.any?

          index.filter :and, filters
        end
      end

      def search_facets(index)
        if @facets.any?

          @facets.each do |field, facet|
            facet_options = Hash.new

            # global facets
            facet_options[:global]       = @options[:global_facets]
            facet_options[:facet_filter] = facet_filter(@query.except(field), @terms.except(field))
            facet_options[:size]         = facet.size

            build_facet(index, field, field, facet, facet_options)

            # facets for selected values
            if @query[field] || @terms[field]
              facet_options[:global]       = false
              facet_options[:facet_filter] = facet_filter(@query, @terms)
              facet_options[:size]         = facet.size

              build_facet(index, selected_field(field), field, facet, facet_options)
            end
          end

        end
      end

      def search_sort(index)
        if @sort_block
          index.sort @sort_block
        end
      end

      def search_highlights(index)
        options = @highlights.find_all { |f| @query.key?(f) }.map { |e| analyzed_field(e) }

        index.highlight(*options)
      end
    end
  end
end
