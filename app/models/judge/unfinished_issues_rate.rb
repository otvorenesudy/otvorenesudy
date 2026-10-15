# frozen_string_literal: true

# Per year, the judge's unfinished cases against the cases assigned (table N).
class Judge
  module UnfinishedIssuesRate
    extend ActiveSupport::Concern

    def unfinished_issues_rate
      summaries = statistical_summaries.by_prominent_court_type(self)

      return unless summaries.any?

      summaries.to_h do |summary|
        table = summary.tables.by_name('N').first
        accepted = Judge::StatisticalTables.row_sum(table.rows[0])
        unfinished = Judge::StatisticalTables.row_sum(table.rows[1])
        unfinished -= table.rows[2..3].sum { |row| Judge::StatisticalTables.row_sum(row) }

        [summary.year, accepted.zero? ? 0.0 : unfinished / accepted.to_f]
      end
    end
  end
end
