module Document
  module Searchable

    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods

      def search_by(params)
        format_result(compose_search(params))
      end

      private 

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
          next if values['terms'].nil? 

          result[field.to_sym] = values['terms'].map { |e| e.symbolize_keys }
        end

        result
      end
     
      def format_result(result)
        data = Hash.new

        data[:results] = fetch_records(result.results)
        data[:facets]  = format_facets(result.facets)

        return data, result
      end

      def compose_search(params, &block)
        page       = params[:page]      || 1
        per_page   = params[:per_page]  || 10
        query      = params[:query]     || Hash.new
        terms      = params[:filter]    || Hash.new
        facets     = params[:facets]    || []
        options    = params[:options]   || {}
        sort_block = params[:sort]

        options[:global_facets] ||= false

        facets = [facets] unless facets.respond_to?(:each)

        results = tire.search page: page, per_page: per_page do |index|

          if block
            block.call(index)
          else
            query(index, query, terms, options)
            facets(index, facets, terms, options)
            sort(index, sort_block, options)
          end

        end

        results
      end

      def query(index, query, terms, options)
        if query.any? or terms.any?
          index.query do
            boolean do
              query.each do |field, values|

                case 
                when values.is_a?(Range)

                  must { range field, { gte: values.min, lte: values.max } }

                else

                  must { string "*#{values}*", default_field: "#{field}.analyzed", default_operator: :and, analyze_wildcard: true  }

                end

              end

              terms.each do |field, value|
                field = "#{field}.untouched"

                if value.respond_to?(:each)

                  value.each do |e|
                    must { term field, e }
                  end

                else

                  must { term field, value }

                end

              end
            end
          end
        end
      end

      def facets(index, facets, terms, options)
        if facets.any?
          facets.each do |facet|

            index.facet facet.to_s, global: options[:global_facets] do 
              terms "#{facet}.untouched"

              if terms.any?
                filter_values = []

                terms.except(facet).each do |field, value|
                  if value.respond_to?(:each)

                    value.each do |e|
                      filter_values << { term: { "#{field}.untouched" => e } }
                    end

                  else

                    filter_values << { term: { "#{field}.untouched" => value } }

                  end
                end

                facet_filter :and, filter_values if filter_values.any?
              end
            end
          end
        end
      end

      def sort(index, sort_block, options)
        if sort_block
          index.sort sort_block
        end
      end

    end
  end
end
