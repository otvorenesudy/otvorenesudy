module Document
  module Searchable

    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods

      # TODO: hard refactoring and handle sorting
      def _search(params)
        params[:page]   ||= 1
        params[:per_page] = 10

        query = params[:search][:query]  || {}
        terms = params[:search][:filter] || {}

        facets = params[:search][:facets]

        tire.search do
          query do
            boolean do 
              query.each do |field, values|

                case 
                when values.is_a?(Range)

                  must { range field, { gte: values.min, lte: values.max } }

                else

                  must { string "*#{values}*", default_field: "#{field}.analyzed", default_operator: :and, analyze_wildcard: true }

                end
              end

              terms.each do |field, values|
                must { term "#{field}.untouched", values }
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

        end
      end
    end
  end
end
