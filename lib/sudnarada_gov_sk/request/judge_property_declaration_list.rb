module SudnaradaGovSk
  class Request
    class JudgePropertyDeclarationList < SudnaradaGovSk::Request::List
      def self.url
        @url ||= "http://mps.sudnarada.gov.sk/majetkove-priznania-sudcov/"
      end
    end
  end
end
