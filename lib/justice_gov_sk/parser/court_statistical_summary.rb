# encoding: utf-8

module JusticeGovSk
  class Parser
    class CourtStatisticalSummary < JusticeGovSk::Parser::StatisticalSummary

      def year
        normalize(@data[1])
      end

      def table
        name   = "Priemerná výkonnosť (súd/SR)"
        column = @data[2]

        data = {
          Pocet1: @data[3],
          Pocet2: @data[4],
          Pocet3: @data[5],
          Pocet4: @data[6],
          Pocet5: @data[7]
        }

        return normalize(name), normalize(column), normalize_and_filter(data)
      end

    end
  end
end
