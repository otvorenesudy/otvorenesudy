module JusticeGovSk
  class Crawler
    class SelectionProcedureCandidate < JusticeGovSk::Crawler
      def initialize(options)
        super(options)

        @procedure = options[:procedure]
      end

      protected

      def process(request)
        super do
          uri = JusticeGovSk::Request.uri(request)

          @candidate = selection_procedure_candidate_by_uri_factory.find_or_create(uri)

          @candidate.uri = uri
          @candidate.procedure = @procedure

          @candidate.name = @parser.name(@document)
          @candidate.name_unprocessed = @parser.name_unprocessed(@document)
          @candidate.accomplished_expectations = @parser.accomplished_expectations(@document)
          @candidate.oral_score = @parser.oral_score(@document)
          @candidate.oral_result = @parser.oral_result(@document)
          @candidate.written_score = @parser.written_score(@document)
          @candidate.written_result = @parser.written_result(@document)
          @candidate.score = @parser.score(@document)
          @candidate.rank = @parser.rank(@document)
          @candidate.judge = judge_by_name_factory.find(@candidate.name)

          # TODO crawl documents for candidate (see parser for urls)

          @candidate
        end
      end
    end
  end
end
