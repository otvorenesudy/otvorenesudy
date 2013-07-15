# TODO: #249

module Judge::UnfinishedIssuesRate
  def unfinished_issues_rate
    tables = statistical_tables.by_name('N')

    accepted = 0
    all      = 0

    return unless tables.any?

    tables.each do |table|
      next unless table.rows[5]

      accepted = table.rows[0].cells.pluck(:value).map(&:to_i).sum

      all = table.rows[1].cells.pluck(:value).map(&:to_i).sum

      table.rows[2..3].each do |row|
        all -= row.cells.pluck(:value).map(&:to_i).sum
      end
    end

    all / accepted.to_f
  end
end
