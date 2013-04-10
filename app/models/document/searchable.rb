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

      # TODO: deprecated in favor of default tire AR results load
      def fetch_records(hits)
        return [] unless hits

        hits.map do |hit|
          self.find(hit.id)
        end
      end

      def format_facets(facets)
        result = Hash.new

        return result unless facets

        facets.each do |field, values|
          field  = field.to_sym
          facet  = @facets[field]

          facet.populate(values)

          result[field] = facet.values
        end

        result
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
        page       = params[:page]       || 1
        per_page   = params[:per_page]   || 10
        query      = params[:query]      || Hash.new
        terms      = params[:filter]     || Hash.new
        facets     = params[:facets]     || @facets
        highlights = params[:highlights] || @highlights
        options    = params[:options]    || {}
        sort_block = params[:sort]

        options[:global_facets] ||= false

        facets = [facets] unless facets.respond_to?(:each)

        results = tire.search page: page, per_page: per_page do |index|

          search_query(index, query, terms, options)
          search_facets(index, facets, query, terms, options)
          search_sort(index, sort_block, options)
          search_highlights(index, query, highlights, options)

        end

        results
      end

      private

      def search_query(index, query, terms, options)
        if query.any? or terms.any?

          index.query do |q|
            q.boolean do |bool|

              query.each do |field, values|
                field = analyzed(field)

                bool.must { string "#{values}*", default_field: field, default_operator: :and, analyze_wildcard: true }
              end

              terms.each do |field, value|
                field = not_analyzed(field)

                case
                when value.is_a?(Range)

                  bool.must { range field, { gte: value.min, lte: value.max }}

                when value.respond_to?(:each)

                  value.each { |e| bool.must { term field, e }}

                else

                  bool.must { term field, value }

                end
              end

            end
          end
        end
      end

      def search_facets(index, facets, query, terms, options)
        if facets.any?

          facets.each do |field, facet|

            facet_options = Hash.new

            facet_options[:global]       = options[:global_facets]
            facet_options[:facet_filter] = facet_filter(query.except(field), terms.except(field))

            # TODO: add ordering (for dates, etc)
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

      def facet_filter(query, terms)
        filter = Hash.new

        filter[:and] = facet_filter_values(query, terms) if query.any? or terms.any?

        filter
      end

      def facet_filter_values(query, terms)
        filter_values = []

        query.each do |field, value|
          filter_values << {
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

        terms.each do |field, value|

          case
          when value.is_a?(Range)

            filter_values << { range: { not_analyzed(field) => { gte: value.min, lte: value.max }}}

          when value.respond_to?(:each)

            value.each do |e|
              filter_values << { term: { not_analyzed(field) => e } }
            end

          else

            filter_values << { term: { not_analyzed(field) => value } }

          end
        end

        filter_values
      end

      def search_sort(index, sort_block, options)
        if sort_block
          index.sort sort_block
        end
      end

      def search_highlights(index, query, highlights, options)
        options = highlights.find_all { |f| query.key?(f) }.map { |e| analyzed(e) }

        index.highlight(*options)
      end
    end
  end
end
