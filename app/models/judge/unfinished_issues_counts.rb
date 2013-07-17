# TODO: 225

module Judge::UnfinishedIssuesCounts
  extend ActiveSupport::Concern
  
  def unfinished_issues_counts
    result    = Hash.new
    summaries = statistical_summaries.by_prominent_court_type

    return unless summaries.any?

    summaries.each do |summary|
      table = summary.tables.by_name('N').first

      next unless table.rows[5] # TODO: resolve why the field is missing sometimes

      beginning_of_year = table.rows[5..7].map { |r| r.cells[0].value.to_i }.inject(:-)

      end_of_year = table.rows[1].cells.pluck(:value).map(&:to_i).sum

      table.rows[2..3].each do |row|
        end_of_year -= row.cells.pluck(:value).map(&:to_i).sum
      end

      result[summary.year] = end_of_year - beginning_of_year
    end

    result
  end
end
