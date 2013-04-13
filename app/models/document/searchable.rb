module Document
  module Searchable

    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods

      def search_by(params = {})
        format_result(compose_search(params))
      end

      private

      def fetch_records(hits)
        return [] unless hits

        hits.map do |hit|
          self.find(hit.id)
        end
      end

      def format_facets(results)
        facets = Hash.new

        return facets unless results

        results.each do |field, values|
          field  = field.to_sym
          facet  = @facets[field] # look up our facet wrapper fot the field

          facet.populate(values)

          facets[field] = facet.values
        end

        facets
      end

      def format_result(result)
        data = Hash.new

        data[:results]    = fetch_records(result.results)
        data[:facets]     = format_facets(result.facets)
        data[:highlights] = result.results.map do |res|
          highlights = Hash.new

          @highlights.each do |field|
            highlights[field] = res.highlight[analyzed(field)] if res.highlight
          end

          highlights
        end

        return data, result
      end

      def compose_search(params, &block)
        @page       = params[:page]       || 1
        @per_page   = params[:per_page]   || 10
        @query      = params[:query]      || Hash.new
        @terms      = params[:filter]     || Hash.new
        @facets     = params[:facets]     || @faceted_fields
        @highlights = params[:highlights] || @highlighted_fields
        @options    = params[:options]    || {}
        @sort_block = params[:sort]

        @options[:global_facets] ||= false

        @facets = [@facets] unless @facets.respond_to?(:each)

        results = tire.search page: @page, per_page: @per_page do |index|

          search_query(index)
          search_filter(index)
          search_facets(index)
          search_sort(index)
          search_highlights(index)

          puts JSON.pretty_generate(index.to_hash)
        end

        results
      end

      private

      def search_query(index)
        if @query.any?

          # TODO: refactor, move wildcard for suggest module
          index.query do |q|
            q.boolean do |bool|

              @query.each do |field, values|
                field = analyzed(field)

                bool.must {
                  string "#{values}*",
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
        index.filter :and, build_filters(@terms) if @terms.any?
      end

      def search_facets(index)
        if @facets.any?

          @facets.each do |field, facet|

            facet_options = Hash.new

            facet_options[:global]       = @options[:global_facets]
            facet_options[:facet_filter] = facet_filter(@query.except(field), @terms.except(field))

            index.facet field.to_s, facet_options do |f|

              case facet.type
              when :terms
                f.terms not_analyzed(field)
              when :date
                f.date not_analyzed(field), interval: facet.interval
              end

            end
          end

        end
      end

      def build_query(query)
        filters = []

        query.each do |field, value|
          filters << {
            query: {
              query_string: {
                query: "#{value}*",
                default_field: analyzed(field),
                default_operator: :and,
                analyze_wildcard: true
              }
            }
          }
        end

        filters
      end

      def build_filters(terms)
        filters = []

        terms.each do |field, values|
          field = not_analyzed(field)

          filter = []

          values.each do |value|

            case
            when value.is_a?(Range)
              filter << { range: { field => { gte: value.min, lte: value.max }}}
            else
              filter << { term: { field => value }}
            end

          end

          filters << { or: filter }
        end

        filters
      end

      def facet_filter(query, terms)
        filter = Hash.new

        filter[:and] = build_facet_filter(query, terms) if query.any? or terms.any?

        filter
      end

      def build_facet_filter(query, terms)
        filter_values = []

        filter_values.concat(build_query(query))
        filter_values.concat(build_filters(terms))

        filter_values
      end

      def search_sort(index)
        if @sort_block
          index.sort @sort_block
        end
      end

      def search_highlights(index)
        options = @highlights.find_all { |f| @query.key?(f) }.map { |e| analyzed(e) }

        index.highlight(*options)
      end
    end
  end
end
