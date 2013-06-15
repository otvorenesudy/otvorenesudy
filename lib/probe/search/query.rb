module Probe::Search
  module Query
    private

    def build_query_from(field, terms, options = {})
      values = analyze_query(terms)

      if field == :all
        fields = :_all
      else
        fields = analyzed_field(field)
      end

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

    def escape_query(value)
      value.gsub(/"/, '\"')
    end

    def analyze_query(value)
      value = value.dup
      exact = value.scan(/"[^"]+"/)

      exact.each { |e| value.gsub!(e, '') }

      q = escape_query(value.strip).split(/\s+/).map { |e| "*#{e}*" }.join(' ')

      q.present? || exact.present? ? "#{q} #{exact.join ' '}" : '*'
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
