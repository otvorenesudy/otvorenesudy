module JusticeGovSk
  class Processor
    class StatisticalSummaries < JusticeGovSk::Processor

      def table
        name, column, rows = @parser.table

        @table_name       = statistical_table_name_by_value_factory.find_or_create(name)
        @table_name.value = name

        persist(@table_name)

        @table = statistical_table_by_statistical_summary_id_and_statistical_summary_type_and_statistical_table_name_id_factory.find_or_create(@summary.id, @summary.class.name, @table_name.id)

        @table.statistical_summary_type = @summary.class.name
        
        @table.summary = @summary
        @table.name    = @table_name

        persist(@table)

        @column_name = statistical_table_column_name_by_value_factory.find_or_create(column)
        @column_name.value = column

        persist(@column_name)

        @column = statistical_table_column_by_statistical_table_column_name_id_and_statistical_table_id_factory.find_or_create(@column_name.id, @table.id)

        @column.table = @table
        @column.name  = @column_name

        persist(@column)

        rows.each do |row, value|
          @row_name       = statistical_table_row_name_by_value_factory.find_or_create(row)
          @row_name.value = row

          persist(@row_name)

          @row = statistical_table_row_by_statistical_table_row_name_id_and_statistical_table_id_factory.find_or_create(@row_name.id, @table.id)

          @row.name  = @row_name
          @row.table = @table

          persist(@row)

          @cell = statistical_table_cell_by_statistical_table_column_id_and_statistical_table_row_id_factory.find_or_create(@column.id, @row.id)

          @cell.column = @column
          @cell.row    = @row
          @cell.value  = value

          persist(@cell)
        end
      end

    end
  end
end
