module JusticeGovSk
  class Processor
    class CourtStatisticalSummaries < JusticeGovSk::Processor::StatisticalSummaries
      def initialize
        @parser = inject JusticeGovSk::Parser::CourtStatisticalSummary
      end

      def process(filepath, options = {})
        super(filepath, options) do |record|
          @parser.parse(record)

          @court = court_by_name_factory.find(@parser.court)

          summary
          table
        end
      end

      def summary
        @summary = court_statistical_summary_by_court_id_and_year_factory.find_or_create(@court.id, @parser.year)

        @summary.court  = @court
        @summary.year   = @parser.year
        @summary.uri    = @filepath
        @summary.source = JusticeGovSk.source

        persist(@summary)
      end
    end
  end
end
