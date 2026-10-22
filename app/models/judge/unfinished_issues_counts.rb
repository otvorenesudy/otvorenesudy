# frozen_string_literal: true

# Per year, how many more cases the judge had unfinished at the end of the year than at its start (table N).
class Judge
  module UnfinishedIssuesCounts
    extend ActiveSupport::Concern

    def unfinished_issues_counts
      summaries = statistical_summaries.by_prominent_court_type(self)

      return unless summaries.any?

      summaries.to_h do |summary|
        table = summary.tables.by_name('N').first

        beginning_of_year = table.rows[6].cells[0].value.to_i
        end_of_year = Judge::StatisticalTables.row_sum(table.rows[1])

        [summary.year, end_of_year - beginning_of_year]
      end
    end
  end
end
