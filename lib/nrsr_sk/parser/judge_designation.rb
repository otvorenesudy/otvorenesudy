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
        type = @data[2].strip.squeeze

        type == "n/a" ? nil : type
      end
    end
  end
end
