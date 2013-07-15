# TODO: #224

module Judge::UnresolvedIssuesCounts
  def unresolved_issues_counts
    result = Hash.new
    tables = statistical_tables.by_name('N')

    return unless tables.any?

    tables.each do |table|
      next unless table.rows[4] # TODO: resolve why the field is missing

      beginning_of_year = table.rows[4].cells[0].value.to_i
      end_of_year       = 0

      table.rows[0].cells.each do |cell|
        end_of_year += cell.value.to_i
      end

      result[table.summary.year] = end_of_year - beginning_of_year
    end

    result
  end
end
