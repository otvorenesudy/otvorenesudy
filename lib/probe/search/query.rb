module Probe::Search
  module Query
    include Probe::Sanitizer

    private

    def build_match_all_query
      { query: { match_all: {} } }
    end

    def build_query_from(field, terms, options = {})
      values = analyze_query_string(terms, force_wildcard: options[:force_wildcard])

      query_options = build_query_options(analyzed_field(field), options)

      query = { query_string: { query: values }}

      query[:query_string].merge! query_options

      query
    end

    def build_filtered_query_from(queries, filter)
      query = Hash.new

      return build_match_all_query if queries.nil? && filter.nil?

      query.merge! filter: filter if filter
      query.merge! query: { bool: queries } if queries

      { query: { filtered: query }}
    end

    def analyze_query_string(value, options = {})
      value = value.dup

      exact = value.scan(/"[^"]+"/)

      exact.map do |e|
        value.gsub!(e, '')

        sanitize_query_string(e)
      end

      q = sanitize_query_string(value.gsub(/"/, '').strip)

      q = q.split(/\s+/).map { |e| "#{e}*" }.join(' ') if options[:force_wildcard]

      q.present? || exact.present? ? "#{q} #{exact.join(' ')}".strip : "*"
    end

    def build_query_options(fields, options = {})
      other = {
        default_operator: options[:default_operator] || :or,
        analyze_wildcard: options[:analyze_wildcard] || true
      }

      other[:fields] = Array.wrap(fields) if fields

      other
    end
  end
end
