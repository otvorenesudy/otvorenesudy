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
        return @data[2] && @data[2] != 'n/a' ? @data[2].strip.squeeze.upcase_first : nil
      end
    end
  end
end
