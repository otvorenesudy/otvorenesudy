module Document
  module Search
    module Query

      def escape_query(value)
        value.gsub(/"/, '\"')
      end

      def prepare_query(value)
        q = escape_query(value).split(/\s/).map { |e| "#{e}*" }.join(' ')

        q.present? ? q : "*"
      end

      def build_query(query)
        filters = []

        query.each do |field, value|
          filters << {
            query: {
              query_string: {
                query: "#{prepare_query(value)}",
                default_field: analyzed_field(field),
                default_operator: :and,
                analyze_wildcard: true
              }
            }
          }
        end

        filters
      end

    end
  end
end
