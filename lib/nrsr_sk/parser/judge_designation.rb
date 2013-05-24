# encoding: utf-8

module NrsrSk
  class Parser
    class JudgeDesignation
      def parse(data)
        @data = data
      end

      def judge
        @data[0].strip.squeeze
      end

      def date
        Date.parse(@data[1])
      end

      def designation_type
        if @data[2] && @data[2] != 'n/a'
          type = @data[2].strip.squeeze.upcase_first
          
          return "Bez časového obmedzenia funkcie" if type =~ /bez\s+obmedzenia/i
          
          type
        end
      end
    end
  end
end
