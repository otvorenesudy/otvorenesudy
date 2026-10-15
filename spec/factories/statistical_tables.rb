# frozen_string_literal: true

FactoryBot.define do
  # A table of a judge's statistical summary (2011, 2012), as the dataset loader stores it: `table_name` is its letter
  # ('N' the cases, 'O' the appeals, 'P' the assigned cases) and `rows` its cells by row and column name, in order:
  # { 'sv_Pocet1' => { 'C' => '6', 'T' => '2' } }.
  factory :statistical_table do
    summary factory: %i[judge_statistical_summary]

    transient do
      table_name { 'N' }
      rows { {} }
    end

    name { StatisticalTableName.find_or_create_by!(value: table_name) }

    after(:create) do |table, context|
      context.rows.each do |row_name, cells|
        row = table.rows.create!(name: StatisticalTableRowName.find_or_create_by!(value: row_name))

        cells.each do |column_name, value|
          name = StatisticalTableColumnName.find_or_create_by!(value: column_name)
          column = table.columns.find_or_create_by!(name:)

          StatisticalTableCell.create!(row:, column:, value:)
        end
      end
    end
  end
end
