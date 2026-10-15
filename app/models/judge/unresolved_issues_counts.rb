# frozen_string_literal: true

# Per year, how many more cases the judge had unresolved at the end of the year than at its start (table N).
class Judge
  module UnresolvedIssuesCounts
    extend ActiveSupport::Concern

    def unresolved_issues_counts
      summaries = statistical_summaries.by_prominent_court_type(self)

      return unless summaries.any?

      summaries.to_h do |summary|
        table = summary.tables.by_name('N').first

        beginning_of_year = table.rows[5].cells[0].value.to_i
        end_of_year = table.rows[0].cells.sum { |cell| cell.value.to_i }

        [summary.year, end_of_year - beginning_of_year]
      end
    end
  end
end
