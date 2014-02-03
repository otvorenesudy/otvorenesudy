module SudnaradaGovSk
  class Crawler
    class JudgePropertyDeclarationList < SudnaradaGovSk::Crawler::List
      protected

      def process(request)
        crawler = SudnaradaGovSk.build_crawler JudgePropertyDeclaration, @options

        super(request) do |item|
          SudnaradaGovSk.run_crawler crawler, SudnaradaGovSk::Request::JudgePropertyDeclaration.new(item), @options
        end
      end
    end
  end
end
