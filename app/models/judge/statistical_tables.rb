# frozen_string_literal: true

# Reading the statistical tables of the judge statistical summaries (2011, 2012): the sum of a row's cells.
class Judge
  module StatisticalTables
    module_function

    def row_sum(row)
      row.cells.pluck(:value).sum(&:to_i)
    end
  end
end
