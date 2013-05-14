module SudnaradaGovSk
  class Request
    class JudgePropertyDeclaration < SudnaradaGovSk::Request
      attr_accessor :court

      def initialize(options = {})
        @url   = options[:url]   || raise
        @court = options[:court] || raise
      end
    end
  end
end
