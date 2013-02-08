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
          result[field.to_sym] = values['terms'].map { |e| e.symbolize_keys } 
        end

        result
      end
     
      def format_result(result)
        data = Hash.new

        data[:results] = fetch_records(result.results)
        data[:facets]  = format_facets(result.facets)

        data
      end

      def compose_search(params)
        puts params.inspect

        page       = params[:page]      || 1
        per_page   = params[:per_page]  || 10
        query      = params[:query]     || Hash.new
        terms      = params[:filter]    || Hash.new
        facets     = params[:facets]
        sort_block = params[:sort]

        results = tire.search do

          if query.any? or terms.any?
            query do
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

          if facets.respond_to?(:each)

            facets.each do |field|

              facet field.to_s do 
                terms "#{field}.untouched"
              end

            end

          elsif facets

            facet facets.to_s do
              terms "#{facets}.untouched"
            end

          end

          if sort_block
            sort sort_block
          end
        end

        results
      end
    end
  end
end
