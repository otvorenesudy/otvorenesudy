module Judge::UnresolvedIssuesCounts
  extend ActiveSupport::Concern

  def unresolved_issues_counts
    result    = Hash.new
    summaries = statistical_summaries.by_prominent_court_type(self)

    return unless summaries.any?

    summaries.each do |summary|
      table = summary.tables.by_name('N').first

      beginning_of_year = table.rows[5].cells[0].value.to_i
      end_of_year       = 0

      table.rows[0].cells.each do |cell|
        end_of_year += cell.value.to_i
      end

      result[summary.year] = end_of_year - beginning_of_year
    end

    result
  end
end
