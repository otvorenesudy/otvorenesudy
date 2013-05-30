module SudnaradaGovSk
  class Request
    class JudgePropertyDeclaration < SudnaradaGovSk::Request
      attr_accessor :court,
                    :judge

      def initialize(options = {})
        @url   = options[:url]   || raise
        @court = options[:court] || raise
        @judge = options[:judge]
      end
    end
  end
end
