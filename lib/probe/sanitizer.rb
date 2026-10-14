# frozen_string_literal: true

module Probe
  # Makes a listing's params safe to put into a search.
  module Sanitizer
    module_function

    # Operators that make no sense in a court records search; quotes (phrases), * and ? (wildcards) and AND/OR stay.
    SYNTAX = %r{(\+|-|=|&&|\|\||\||\(|\)|\{|\}|\[|\]|\^|~|!|\\|/|:)}

    # Everything Lucene's query syntax reserves, for a second try when Elasticsearch still can't parse a query.
    RESERVED = %r{(\+|-|=|&&|\|\||\||\(|\)|\{|\}|\[|\]|\^|"|~|\*|\?|!|\\|/|:)}

    def page(value, max:)
      page = value.to_i

      page.positive? ? [page, max].min : 1
    end

    def sort(value, sort_fields)
      field = value.to_s.to_sym

      return field if sort_fields.include?(field)

      sort_fields.first || :_score
    end

    def order(value)
      value.to_s == 'asc' ? :asc : :desc
    end

    # < and > can't be escaped in a query string, only removed.
    def query_string(value, escape: :syntax)
      value = value.to_s.delete('<>').gsub(escape == :all ? RESERVED : SYNTAX) { |match| "\\#{match}" }

      return value if escape == :all || value.count('"').even?

      index = value.rindex('"')
      "#{value[0...index]}\\\"#{value[(index + 1)..]}"
    end

    def suggest_string(value)
      value.to_s.delete(%q("'{}[]()))
    end
  end
end
