module JusticeGovSk
  module Crawlers
    class HearingCrawler < Crawler
      include Factories
      include Identify
      include Pluralize 
      
      def initialize(downloader, persistor)
        super(downloader, JusticeGovSk::Parsers::HearingParser.new, persistor)
      end
      
      protected
    
      def process(uri, content)
        document = @parser.parse(content)
                
        @hearing = hearing_factory.find_or_create(uri)
        

      end
    end
  end
end
