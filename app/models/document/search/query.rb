module Document
  module Search
    module Query

      def escape_query(value)
        value.gsub(/"/, '\"')
      end

      def analyze_query(value)
        q = escape_query(value).split(/\s/).map { |e| "*#{e}*" }.join(' ')

        q.present? ? q : "*"
      end

      def build_query(query, options = {})
        filters = []

        query.each do |field, value|
          fields = analyzed_field(field)

          filters << {
            query: {
              query_string: {
                query: value,
                fields: fields.is_a?(Array) ? fields : [fields],
                default_operator: options[:operator] || :or,
                analyze_wildcard: options[:analyze_wildcard] || true
              }
            }
          }
        end

        filters
      end

      def build_search_query(query)
        query = Hash[query.map { |k, v| [k, analyze_query(v)] }]

        build_query(query)
      end

      def build_suggest_query(query)
        analyzed_query = Hash[query.map { |k, v| [k, analyze_query(v) ] }]

        build_query(analyzed_query, operator: :and)
      end


    end
  end
end
