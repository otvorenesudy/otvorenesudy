# Usage:
#
# rake process:court_expenses:2010
# rake process:court_statistical_summaries:2011
#
# rake process:judge_designations:nrsr_sk
# rake process:judge_statistical_summaries:2011

namespace :process do
  namespace :court_expenses do
    desc "Process court expenses from 2010"
    task :'2010' => :environment do
      processor = JusticeGovSk::Processor::CourtExpenses.new

      processor.process('data/court_expenses_2010.csv')
    end

    desc "Process court expenses from 2011"
    task :'2011' => :environment do
      processor = JusticeGovSk::Processor::CourtExpenses.new

      processor.process('data/court_expenses_2011.csv')
    end

    desc "Process court expenses from 2012"
    task :'2012' => :environment do
      processor = JusticeGovSk::Processor::CourtExpenses.new

      processor.process('data/court_expenses_2012.csv')
    end
  end

  desc "process court statistical summaries"
  namespace :court_statistical_summaries do
    desc "process court statistical summaries from 2011"
    task :'2011' => :environment do
      processor = justicegovsk::processor::courtstatisticalsummaries.new

      processor.process('data/court_statistical_summaries_2011.csv')
    end

    desc "process court statistical summaries from 2012"
    task :'2012' => :environment do
      processor = justicegovsk::processor::courtstatisticalsummaries.new

      processor.process('data/court_statistical_summaries_2012.csv')
    end
  end

  namespace :judge_designations do
    desc "Process judge designations from Nrsr.sk"
    task :nrsr_sk do
      processor = NrsrSk::Processor::JudgeDesignations.new

      options = { separator: "\t" }

      processor.process('data/judge_designations_nrsr.csv', options)
    end

    desc "Process judge designations from 2013 by president"
    task :'2013_president' => :environment do
      processor = NrsrSk::Processor::JudgeDesignations.new

      options = { separator: "\t" }

      processor.process('data/judge_designations_2013_president.csv', options)
    end
  end

  namespace :judge_statistical_summaries do
    desc "Process judge statistical summaries from 2011"
    task :'2011' => :environment do
      processor = JusticeGovSk::Processor::JudgeStatisticalSummaries.new

      processor.process('data/judge_statistical_summaries_2011.csv')
    end

    desc "process court statistical summaries from 2012"
    task :'2012' => :environment do
      processor = JusticeGovSk::Processor::JudgeStatisticalSummaries.new

      processor.process('data/judge_statistical_summaries_2012.csv')
    end
  end
end
