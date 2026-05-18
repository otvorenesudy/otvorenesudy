module Probe::Search
  module Query
    include Probe::Sanitizer

    private

    def build_query_from(field, terms, options = {})
      values = analyze_query_string(terms, force_wildcard: options[:force_wildcard])
      fields = Array.wrap(analyzed_field(field)).map(&:to_s)

      {
        query_string: {
          fields: fields,
          query: values,
          default_operator: (options[:operator] || :or).to_s.upcase,
          analyze_wildcard: options.fetch(:analyze_wildcard, true)
        }
      }
    end

    def build_query_filter_from(field, terms, options = {})
      build_query_from(field, terms, options)
    end

    def build_filtered_query_from(queries, filter)
      must = Array.wrap(queries).compact
      filters = Array.wrap(filter).compact

      bool = {}
      bool[:must] = must if must.any?
      bool[:filter] = filters if filters.any?

      bool.any? ? { bool: bool } : { match_all: {} }
    end

    def extract_page_param(params)
      params[:page].to_i
    end

    def extract_order_param(params)
      %w[asc desc].include?(params[:order].to_s) ? params[:order].to_sym : :desc
    end

    def extract_sort_param(params, sort_fields)
      field = params[:sort].to_sym
      sort_fields.include?(field) ? field : sort_fields.first
    end

    def analyze_query_string(value, options = {})
      value = sanitize_query_string(value.to_s.dup)
      value += '*' if options[:force_wildcard]
      value
    end
  end
end
