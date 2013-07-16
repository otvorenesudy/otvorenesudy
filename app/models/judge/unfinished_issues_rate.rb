# TODO: #249

module Judge::UnfinishedIssuesRate
  def unfinished_issues_rate
    result    = Hash.new
    summaries = statistical_summaries.by_prominent_court_type

    return unless summaries.any?

    summaries.each do |summary|
      table = summary.tables.by_name('N').first

      next unless table.rows[5]

      accepted = table.rows[0].cells.pluck(:value).map(&:to_i).sum
      all      = table.rows[1].cells.pluck(:value).map(&:to_i).sum

      table.rows[2..3].each do |row|
        all -= row.cells.pluck(:value).map(&:to_i).sum
      end

      result[summary.year] = all / accepted.to_f
    end

    result
  end
end
