# frozen_string_literal: true

# Records whose column is similar to a value, by trigram similarity (pg_trgm), grouped by similarity:
# `Judge.similar_by_name('Ján Novák', limit: 0.55)` => { 1.0 => [judge], 0.62 => [judge, judge] }.
module Resource
  module Similarity
    extend ActiveSupport::Concern

    FUNCTIONS = %w[unaccent].freeze

    class_methods do
      def similar_by(column, value, options = {})
        limit = options.fetch(:limit, 1.0).to_f

        raise ArgumentError, "Similarity limit #{limit} isn't in (0, 1]" unless limit.positive? && limit <= 1.0

        expression = similarity_expression(column, options[:function])

        similarity = "similarity(#{expression[:column]}, #{expression[:value]})"
        rows = connection.select_rows(sanitize_sql_array([<<~SQL.squish, value, value, limit]))
          SELECT id, #{similarity} FROM #{quoted_table_name} WHERE #{similarity} >= ? ORDER BY 2 DESC
        SQL

        records = where(id: rows.map(&:first)).index_by(&:id)

        rows.group_by { |_, similarity| similarity.to_f }.transform_values do |group|
          group.map { |id, _| records[id] }
        end
      end

      def similar_by_name(value, options = {})
        similar_by(:name, value, options)
      end

      private

      def similarity_expression(column, function)
        column = connection.quote_column_name(column.to_s)

        return { column:, value: '?' } unless function

        raise ArgumentError, "Unknown function #{function}" unless FUNCTIONS.include?(function.to_s)

        { column: "#{function}(#{column})", value: "#{function}(?)" }
      end
    end
  end
end
