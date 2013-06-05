module Document
  module Search
    module Query
      def build_query_from(field, terms, options = {})
        fields = analyzed_field(field)
        values = analyze_query(terms)

        query_options = build_query_options(fields, options)

        if block_given?
          yield(fields, values, query_options)
        else
          Proc.new { string values, query_options }
        end
      end

      def build_query_filter_from(field, terms, options = {})
        build_query_from(field, terms, options) do |fields, values, query_options|
          filter = { query: { query_string: { query: values }}}

          filter[:query][:query_string].merge! query_options

          filter
        end
      end

      private

      def escape_query(value)
        value.gsub(/"/, '\"')
      end

      def analyze_query(value)
        exact = value.scan(/"[^"]+"/)

        exact.each { |e| value.gsub!(e, '') }

        q = escape_query(value.strip).split(/\s+/).map { |e| "*#{e}*" }.join(' ')

        q.present? || exact.present? ? "#{q} #{exact.join(' ')}" : "*"
      end

      def build_query_options(fields, options)
        {
          fields:           fields.is_a?(Array) ? fields : [fields],
          default_operator: options[:operator] || :or,
          analyze_wildcard: options[:analyze_wildcard] || true
        }
      end
    end
  end
end
