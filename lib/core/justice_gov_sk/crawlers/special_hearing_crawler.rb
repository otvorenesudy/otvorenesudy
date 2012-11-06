module JusticeGovSk
  module Crawlers
    class SpecialHearingCrawler < HearingCrawler
      def initialize(downloader, persistor)
        super(downloader, JusticeGovSk::Parsers::SpecialHearingParser.new, persistor)
      end
      
      protected
    
      def process(uri, content)
        super(uri, content)        


        
        @persistor.persist(@hearing)
      end
    end
  end
end
