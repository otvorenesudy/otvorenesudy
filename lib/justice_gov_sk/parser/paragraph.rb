# encoding: utf-8

module JusticeGovSk
  class Parser
    class Paragraph < JusticeGovSk::Parser
      def parse(data)
        @data = data
      end

      def number
        return *@data[0].strip.match(/\A§\s*(?<paragraph>\d+[a-z]*)\z/)
      end

      def description
        @data[1].strip.squeeze(' ')
      end
    end
  end
end
