module Judge::AppealCourtAcceptanceRate
  def appeal_court_acceptance_rate
    tables = statistical_tables.by_name("O")

    accepted = 0
    all      = 0

    return unless tables.any?

    # TODO: equation (accepted_2011 + accepted_2012)/(all_2011 + all_2012)
    tables.each do |table|
      table.rows.each do |row|
        sum = row.cells.pluck(:value).map(&:to_i).sum

        if row.name.value == "sv_Pocet1"
          accepted += sum
        end

        all += sum
      end
    end

    accepted / all.to_f
  end

  alias :appeal_court_acceptance_rate? :appeal_court_acceptance_rate
end
