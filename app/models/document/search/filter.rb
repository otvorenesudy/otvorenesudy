module Document
  module Search
    module Filter

      def build_filters(terms)
        filters = []

        terms.each do |field, values|
          field = not_analyzed_field(field)

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

    end
  end
end
