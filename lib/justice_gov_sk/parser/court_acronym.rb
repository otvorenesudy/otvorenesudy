module JusticeGovSk
  class Parser
    class CourtAcronym
      include JusticeGovSk::Helper::Normalizer

      def parse(data)
        @data = data
      end

      def court
        normalize_court_name(@data[0])
      end

      def acronym
        @data[1].squeeze(' ').strip
      end
    end
  end
end
