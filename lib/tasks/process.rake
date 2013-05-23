# Usage:
#
# rake process:judge_designations
# rake process:judge_statistical_summaries

namespace :process do
  desc "Process judge designations"
  task judge_designations: :environment do
    processor = NrsrSk::Processor::JudgeDesignations.new

    options = { separator: "\t" }

    Dir.glob('data/judge_designations_*.csv') do |file|
      processor.process(file, options)
    end
  end

  desc "Process judge statistical summaries"
  task judge_statistical_summaries: :environment do
    processor = JusticeGovSk::Processor::JudgeStatisticalSummaries.new

    options = { separator: "\t" }

    processor.process("#{Rails.root}/data/judge_statistical_summaries_2012.csv")
  end

  desc "Process court statistical summaries"
  task court_statistical_summaries: :environment do
    processor = JusticeGovSk::Processor::CourtStatisticalSummaries.new

    options = { separator: "\t" }

    processor.process("#{Rails.root}/data/court_statistical_summaries_2012.csv")
  end

end
