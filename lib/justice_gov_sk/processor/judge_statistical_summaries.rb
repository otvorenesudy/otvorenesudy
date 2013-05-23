module JusticeGovSk
  class Processor
    class JudgeStatisticalSummaries < JusticeGovSk::Processor::StatisticalSummaries
      def initialize
        @parser = inject JusticeGovSk::Parser::JudgeStatisticalSummary
      end

      def process(path, options = {})
        super(path, options) do |record|
          @parser.parse(record)

          judge_name = @parser.judge
          judges_map = match_judges_by(judge_name)

          _, matched_judges = judges_map.first

          next if matched_judges.blank? || matched_judges.count > 1

          @judge = matched_judges.first
          @court = court_by_name_factory.find @parser.court

          summary
          table
        end
      end

      private

      def summary
        @summary = judge_statistical_summary_by_court_id_and_judge_id_and_year_factory.find_or_create(@court.id, @judge.id, @parser.year)

        @summary.court  = @court
        @summary.judge  = @judge
        @summary.year   = @parser.year
        @summary.uri    = @file
        @summary.source = JusticeGovSk.source

        @summary.update_attributes(@parser.summary)

        if @parser.senate_inclusion
          senate_inclusion = judge_senate_inclusion_by_value_factory.find_or_create(@parser.senate_inclusion)

          senate_inclusion.value = @parser.senate_inclusion

          persist(senate_inclusion)

          @summary.senate_inclusion = senate_inclusion
        end

        persist(@summary)
      end

    end
  end
end
