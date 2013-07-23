module Judge::UnfinishedIssuesRate
  extend ActiveSupport::Concern

  def unfinished_issues_rate
    result    = Hash.new
    summaries = statistical_summaries.by_prominent_court_type(self)

    return unless summaries.any?

    summaries.each do |summary|
      table = summary.tables.by_name('N').first

      accepted = table.rows[0].cells.pluck(:value).map(&:to_i).sum
      all      = table.rows[1].cells.pluck(:value).map(&:to_i).sum

      table.rows[2..3].each do |row|
        all -= row.cells.pluck(:value).map(&:to_i).sum
      end

      result[summary.year] = all / accepted.to_f

      result[summary.year] = 0.0 if result[summary.year].nan?
    end

    result
  end
end
