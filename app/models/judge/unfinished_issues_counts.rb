module Judge::UnfinishedIssuesCounts
  extend ActiveSupport::Concern

  def unfinished_issues_counts
    result    = Hash.new
    summaries = statistical_summaries.by_prominent_court_type(self)

    return unless summaries.any?

    summaries.each do |summary|
      table = summary.tables.by_name('N').first

      beginning_of_year = table.rows[6].cells[0].value.to_i
      end_of_year       = table.rows[1].cells.pluck(:value).map(&:to_i).sum

      result[summary.year] = end_of_year - beginning_of_year
    end

    result
  end
end
