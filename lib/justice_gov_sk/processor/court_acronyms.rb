module JusticeGovSk
  class Processor
    class CourtAcronyms < JusticeGovSk::Processor
      def initialize
        @parser = inject JusticeGovSk::Parser::CourtAcronym
      end

      def process(filepath, options = {})
        super(filepath, options) do |record|
          @parser.parse(record)

          @court = court_by_name_factory.find @parser.court

          next unless @court

          @court.acronym = @parser.acronym

          persist(@court)
        end
      end
    end
  end
end
