# frozen_string_literal: true

# Loads the frozen datasets in data/ (otvorenesudy-data) that no importer in otvorenesudy-api covers. Each task is
# idempotent: running it again finds the rows it created and updates them.
#
#   bin/rails process:paragraphs
#   bin/rails process:court_acronyms
#   bin/rails process:court_expenses:2010            (2010-2013)
#   bin/rails process:court_statistical_summaries:2011  (2011-2012)
#   bin/rails process:judge_statistical_summaries:2011  (2011-2012)
#   bin/rails process:judge_designations:nrsr_sk     (and :prezident_sk)

require_relative 'dataset_loader'

namespace :process do
  desc 'Load paragraph descriptions from data/paragraphs.csv'
  task paragraphs: :environment do
    DatasetLoader.each_row('data/paragraphs.csv') do |row|
      number = row[1].strip.match(/\A§*\s*\d+[a-z]*\z/)[0].gsub(/§*\s*/, '')
      paragraph = Paragraph.find_or_initialize_by(legislation: row[0].strip, number:)

      paragraph.update!(description: row[2].strip.squeeze(' '))
    end
  end

  desc 'Load court acronyms from data/court_acronyms.csv'
  task court_acronyms: :environment do
    DatasetLoader.each_row('data/court_acronyms.csv') do |row|
      court = DatasetLoader.court(row[0])

      court&.update!(acronym: row[1].squeeze(' ').strip)
    end
  end

  namespace :court_expenses do
    %w[2010 2011 2012 2013].each do |year|
      desc "Load court expenses from data/court_expenses_#{year}.csv"
      task year => :environment do
        path = "data/court_expenses_#{year}.csv"

        DatasetLoader.each_row(path) do |row|
          court = DatasetLoader.court!(row[0])
          value = row[2].squeeze(' ').strip
          expense = CourtExpense.find_or_initialize_by(court:, year: row[1].squeeze(' ').strip, value:)

          expense.update!(uri: path, source: DatasetLoader.source(:JusticeGovSk))
        end
      end
    end
  end

  namespace :court_statistical_summaries do
    %w[2011 2012].each do |year|
      desc "Load court statistical summaries from data/court_statistical_summaries_#{year}.csv"
      task year => :environment do
        path = "data/court_statistical_summaries_#{year}.csv"

        DatasetLoader.each_row(path) do |row|
          court = DatasetLoader.court!(row[0])
          summary = CourtStatisticalSummary.find_or_initialize_by(court:, year: DatasetLoader.value(row[1]))

          summary.update!(uri: path, source: DatasetLoader.source(:JusticeGovSk))

          counts = DatasetLoader::COURT_COUNTS.zip(row.fields(3..7)).to_h

          DatasetLoader.table(summary, 'Priemerná výkonnosť (súd/SR)', DatasetLoader.value(row[2]), counts)
        end
      end
    end
  end

  namespace :judge_statistical_summaries do
    %w[2011 2012].each do |year|
      desc "Load judge statistical summaries from data/judge_statistical_summaries_#{year}.csv"
      task year => :environment do
        path = "data/judge_statistical_summaries_#{year}.csv"

        DatasetLoader.each_row(path) do |row|
          judge = DatasetLoader.judge("#{row[5]} #{row[1]} #{row[2]}".squeeze(' ').strip)

          next unless judge

          court = DatasetLoader.court!(row[0])
          summary = JudgeStatisticalSummary.find_or_initialize_by(court:, judge:, year: DatasetLoader.value(row[3]))

          summary.assign_attributes(
            DatasetLoader.values(
              days_worked: row[6],
              days_heard: row[7],
              days_used: row[8],
              released_constitutional_decrees: row[9],
              delayed_constitutional_decrees: row[10],
              idea_reduction_reasons: row[11],
              educational_activities: row[12],
              court_chair_actions: row[13],
              substantiation_notes: row[14]
            )
          )

          if (inclusion = DatasetLoader.value(row[4]))
            summary.senate_inclusion = JudgeSenateInclusion.find_or_create_by!(value: inclusion)
          end

          summary.update!(uri: path, source: DatasetLoader.source(:JusticeGovSk))

          name = DatasetLoader.value(row[25])
          counts = DatasetLoader::JUDGE_COUNTS.zip(row.fields(20..24)).to_h
          counts.merge!(DatasetLoader::JUDGE_TRANSFERS.zip(row.fields(15..18)).to_h) if name == 'N'

          DatasetLoader.table(summary, name, DatasetLoader.value(row[19]), counts)
        end
      end
    end
  end

  namespace :judge_designations do
    { nrsr_sk: :NrsrSk, prezident_sk: :PrezidentSk }.each do |name, source|
      desc "Load judge designations from data/judge_designations_#{name}.csv"
      task name => :environment do
        path = "data/judge_designations_#{name}.csv"

        DatasetLoader.each_row(path) do |row|
          judge = DatasetLoader.judge(row[0].strip.squeeze(' '))

          next unless judge

          designation = JudgeDesignation.find_or_initialize_by(judge:, date: Date.parse(row[1]))
          type = row[2].present? && row[2] != 'n/a' ? row[2].strip.squeeze(' ').upcase_first : nil
          type = 'Bez časového obmedzenia funkcie' if type&.match?(/bez\s+obmedzenia/i)

          designation.type = JudgeDesignationType.find_or_create_by!(value: type) if type
          designation.update!(uri: path, source: DatasetLoader.source(source))
        end
      end
    end
  end
end
