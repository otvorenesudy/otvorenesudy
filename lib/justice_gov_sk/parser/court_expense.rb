module JusticeGovSk
  class Parser
    class CourtExpense
      include JusticeGovSk::Helper::Normalizer

      def parse(data)
        @data = data
      end

      def court
        court = @data[0].gsub('-', '').squeeze(' ').strip

        court_name_map[court.ascii.downcase] || court
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
