module SudnaradaGovSk
  class Crawler
    class List < SudnaradaGovSk::Crawler
      include Core::Crawler::List

      def initialize(options = {})
        @options = options
        @type    = @options[:type]

        @downloader = inject SudnaradaGovSk::Agent,     implementation: @type, suffix: :List
        @parser     = inject SudnaradaGovSk::Parser,    implementation: @type, suffix: :List
        @persistor  = inject SudnaradaGovSk::Persistor, implementation: @type, suffix: :List
      end

      protected

      def process(request)
        return super(request) if block_given?

        crawler = SudnaradaGovSk.build_crawler @type, @options

        super(request) do |url|
          SudnaradaGovSk.run_crawler crawler, url, @options
        end
      end
    end
  end
end
