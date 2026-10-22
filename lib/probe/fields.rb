# frozen_string_literal: true

module Probe
  # Where a mapped field is indexed. `analyze :name` indexes the value as is in `name` (keyword, number, date or
  # boolean: filters, aggregations and sorting), as full text in `name.analyzed` and, for strings, lowercased without
  # diacritics in `name.folded` (suggestions). `:all` stands for every analyzed field.
  module Fields
    module_function

    def analyzed(field)
      return Array.wrap(field).map { |f| analyzed(f) } if field.is_a?(Array)
      return '*.analyzed' if field.to_sym == :all

      "#{field}.analyzed"
    end

    def keyword(field)
      field.to_s
    end

    def folded(field)
      "#{field}.folded"
    end
  end
end
