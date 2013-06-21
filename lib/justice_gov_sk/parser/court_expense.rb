module JusticeGovSk
  class Parser
    class CourtExpense
      include JusticeGovSk::Helper::Normalizer

      def parse(data)
        @data = data
      end

      def court
        normalize_court_name(@data[0])
      end

      def year
        @data[1].squeeze(' ').strip
      end

      def value
        @data[2].squeeze(' ').strip
      end

    end
  end
end
