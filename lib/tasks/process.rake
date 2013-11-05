# Usage:
#
# rake process:paragraphs
#
# rake process:court_expenses:2010
# rake process:court_statistical_summaries:2011
#
# rake process:judge_designations:nrsr_sk
# rake process:judge_statistical_summaries:2011

namespace :process do
  desc "Process know paragraph descriptions"
  task paragraphs: :environment do
    processor = JusticeGovSk::Processor::Paragraphs.new

    processor.process('data/paragraphs.csv')
  end

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

  desc "Process court statistical summaries"
  namespace :court_statistical_summaries do
    desc "process court statistical summaries from 2012"
    task :'2011' => :environment do
      processor = JusticeGovSk::Processor::CourtStatisticalSummaries.new

      processor.process('data/court_statistical_summaries_2011.csv')
    end

    desc "process court statistical summaries from 2012"
    task :'2012' => :environment do
      processor = JusticeGovSk::Processor::CourtStatisticalSummaries.new

      processor.process('data/court_statistical_summaries_2012.csv')
    end
  end

  namespace :judge_designations do
    desc "Process judge designations"
    task :nrsr_sk => :environment do
      processor = NrsrSk::Processor::JudgeDesignations.new

      options = { separator: "\t" }

      processor.process('data/judge_designations_nrsr_sk.csv', options)
    end

    desc "Process judge designations"
    task :prezident_sk => :environment do
      processor = NrsrSk::Processor::JudgeDesignations.new

      options = { separator: "\t", source: Source.find_by_module(:PrezidentSk) }

      processor.process('data/judge_designations_prezident_sk.csv', options)
    end
  end

  namespace :judge_statistical_summaries do
    desc "Process judge statistical summaries from 2011"
    task :'2011' => :environment do
      processor = JusticeGovSk::Processor::JudgeStatisticalSummaries.new

      processor.process('data/judge_statistical_summaries_2011.csv')
    end

    desc "Process court statistical summaries from 2012"
    task :'2012' => :environment do
      processor = JusticeGovSk::Processor::JudgeStatisticalSummaries.new

      processor.process('data/judge_statistical_summaries_2012.csv')
    end
  end
end
