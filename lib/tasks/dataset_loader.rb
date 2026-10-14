# frozen_string_literal: true

require 'csv'

# Shared steps of the process:* tasks (lib/tasks/process.rake), which load the frozen datasets in data/.
module DatasetLoader
  # Row names of the statistical tables, as the datasets' columns name them.
  COURT_COUNTS = %w[Pocet1 Pocet2 Pocet3 Pocet4 Pocet5].freeze
  JUDGE_COUNTS = %w[sv_Pocet1 sv_Pocet2 sv_Pocet3 sv_Pocet4 sv_Pocet5].freeze
  JUDGE_TRANSFERS = %w[sv_PrenosN1 sv_PrenosN2 sv_PrenosN3 sv_PrenosN4].freeze

  module_function

  # The datasets are tab-separated with a header row.
  def each_row(path, &)
    lines = 0

    puts "Processing #{path} ..."

    CSV.foreach(Rails.root.join(path), col_sep: "\t", headers: :first_row) do |row|
      yield row

      lines += 1
    end

    puts "done (#{lines} lines read)"
  end

  def court(name)
    Court.find_by(name: NameNormalizer.court_name(name.to_s.strip))
  end

  def court!(name)
    court(name) || raise(ActiveRecord::RecordNotFound, "No court named #{NameNormalizer.court_name(name.to_s.strip)}")
  end

  # Only an exact match counts: the datasets name judges as the source did, and a near match is a different judge.
  def judge(name)
    judges = Judge.similar_by_name(name, limit: 0.55)[1.0]

    if judges&.one?
      judges.first
    else
      puts "Skipping #{name}: #{judges.present? ? 'several judges match' : 'no judge matches'}"
    end
  end

  def source(name)
    Source.find_by!(module: name.to_s)
  end

  def value(data)
    data&.squeeze(' ')&.strip
  end

  def values(data)
    data.transform_values { |v| value(v) }.compact
  end

  # One column of a statistical table: a value per row name.
  def table(summary, name, column, counts)
    table_name = StatisticalTableName.find_or_create_by!(value: name)
    table = StatisticalTable.find_or_create_by!(summary:, name: table_name)
    column = StatisticalTableColumn.find_or_create_by!(
      table:,
      name: StatisticalTableColumnName.find_or_create_by!(value: column)
    )

    values(counts).each do |row_name, count|
      row = StatisticalTableRow.find_or_create_by!(
        table:,
        name: StatisticalTableRowName.find_or_create_by!(value: row_name.to_s)
      )

      StatisticalTableCell.find_or_initialize_by(column:, row:).update!(value: count)
    end
  end
end
