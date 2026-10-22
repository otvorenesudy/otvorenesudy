# frozen_string_literal: true

# The share of the judge's decisions the appeal court upheld (table O of the statistical summaries).
class Judge
  module AppealCourtAcceptanceRate
    extend ActiveSupport::Concern

    class_methods do
      def average_appeal_court_acceptance_rate
        rates = Judge.all.filter_map(&:appeal_court_acceptance_rate)

        rates.sum / rates.size
      end
    end

    def appeal_court_acceptance_rate
      summaries = statistical_summaries.by_prominent_court_type(self)

      return unless summaries.any?

      accepted = 0
      all = 0

      summaries.each do |summary|
        summary.tables.by_name('O').each do |table|
          table.rows.each do |row|
            sum = Judge::StatisticalTables.row_sum(row)

            accepted += sum if row.name.value == 'sv_Pocet1'
            all += sum
          end
        end
      end

      all.zero? ? 0 : accepted / all.to_f
    end
  end
end
