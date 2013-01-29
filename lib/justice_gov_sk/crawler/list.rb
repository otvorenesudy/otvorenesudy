module JusticeGovSk
  class Crawler
    class List < JusticeGovSk::Crawler
      include Core::Crawler::List
      
      def initialize(options = {})
        @options = options
        
        type = options[:type]
        
        @downloader = inject JusticeGovSk::Agent,     implementation: type, suffix: :List
        @parser     = inject JusticeGovSk::Parser,    implementation: type, suffix: :List
        @persistor  = inject JusticeGovSk::Persistor, implementation: type, suffix: :List
      end
      
      protected
      
      def process(request)
        return super(request) if block_given?
        
        crawler = JusticeGovSk.build_crawler options[:type], options
        
        super(request) do |url|
          JusticeGovSk.run_crawler crawler, url, options
        end
      end
    end
  end
end
