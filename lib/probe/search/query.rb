module Probe::Search
  module Query
    include Probe::Sanitizer

    private

    def build_query_from(field, terms, options = {})
      values = sanitize_query_string(terms)

      values = analyze_query_string(values) if options[:force_wildcard]

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
        filter = { query_string: { query: values }}

        filter[:query_string].merge! query_options

        filter
      end
    end

    def build_filtered_query_from(queries, filter)
      query = Hash.new

      return { query: { match_all: {}}} if queries.empty? && filter.nil?

      query.merge! filter: filter if filter
      query.merge! query: { bool: { must: queries }} if queries.any?

      { query: { filtered: query }}
    end

    def analyze_query_string(value)
      value = value.dup

      exact = value.scan(/"[^"]+"/)

      exact.each { |e| value.gsub!(e, '') }

      q = sanitize_query_string(value.strip).split(/\s+/).map { |e| "*#{e}*" }.join(' ')

      q.present? || exact.present? ? "#{q} #{exact.join(' ')}" : "*"
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
