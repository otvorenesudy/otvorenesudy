module JusticeGovSk
  class Crawler
    class SelectionProcedureCandidate < JusticeGovSk::Crawler
      protected

      def process(request)
        super do
          require 'pry'; binding.pry
        end
      end
    end
  end
end
