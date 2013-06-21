# encoding: utf-8

module JusticeGovSk
  class Parser
    class Paragraph < JusticeGovSk::Parser
      def parse(data)
        @data = data
      end

      def legislation
        @data[0].strip
      end

      def number
        @data[1].strip.match(/\A§*\s*(?<paragraph>\d+[a-z]*)\z/)[0].gsub(/§*\s*/, '')
      end

      def description
        @data[2].strip.squeeze(' ')
      end
    end
  end
end
