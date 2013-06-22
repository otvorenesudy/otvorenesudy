module Probe::Search
  module Query
    include Probe::Sanitizer

    private

    def build_query_from(field, terms, options = {})
      values = sanitize_query_string(terms)

      fields = field == :all ? nil : analyzed_field(field)

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

    def analyze_query_string(value)
      value.split(/[[:space:]]/).map { |e| "*#{e}*" }.join(' ')
    end

    def build_query_options(fields, options = {})
      other = {
        default_operator: options[:operator] || :or,
        analyze_wildcard: options[:analyze_wildcard] || true
      }

      other[:fields] = Array.wrap(fields) if fields

      other
    end
  end
end
