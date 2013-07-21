# TODO: 221

module Judge::AppealCourtAcceptanceRate
  def appeal_court_acceptance_rate
    summaries = statistical_summaries.by_prominent_court_type

    accepted = 0
    all      = 0

    return unless summaries.any?

    summaries.each do |summary|
      summary.tables.by_name('O').each do |table|
        table.rows.each do |row|
          sum = row.cells.pluck(:value).map(&:to_i).sum

          if row.name.value == 'sv_Pocet1'
            accepted += sum
          end

          all += sum
        end
      end
    end

    result = accepted / all.to_f

    result.nan? ? 0 : result
  end
end
