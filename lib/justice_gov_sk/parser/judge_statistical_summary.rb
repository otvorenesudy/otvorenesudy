module JusticeGovSk
  class Parser
    class JudgeStatisticalSummary < JusticeGovSk::Parser::StatisticalSummary
      def judge
        judge = "#{@data[5]} #{@data[1]} #{@data[2]}"

        judge.squeeze(' ').strip
      end

      def year
        normalize(@data[3])
      end

      def table
        name   = normalize(@data[25])
        column = normalize(@data[19])

        data = {
          sv_Pocet1:   @data[20],
          sv_Pocet2:   @data[21],
          sv_Pocet3:   @data[22],
          sv_Pocet4:   @data[23],
          sv_Pocet5:   @data[24],
        }

        if name == 'N'
          data.merge!(
            sv_PrenosN1: @data[15],
            sv_PrenosN2: @data[16],
            sv_PrenosN3: @data[17],
            sv_PrenosN4: @data[18],
          )
        end

        return name, column, normalize_and_filter(data)
      end

      def summary
        normalize_and_filter(
          days_worked:                     @data[6],
          days_heard:                      @data[7],
          days_used:                       @data[8],
          released_constitutional_decrees: @data[9],
          delayed_constitutional_decrees:  @data[10],
          idea_reduction_reasons:          @data[11],
          educational_activities:          @data[12],
          court_chair_actions:             @data[13],
          substantiation_notes:            @data[14]
        )
      end

      def senate_inclusion
        normalize(@data[4])
      end
    end
  end
end
