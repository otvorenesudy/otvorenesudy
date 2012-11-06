module JusticeGovSk
  module Crawlers
    class CriminalHearingCrawler < HearingCrawler
      def initialize(downloader, persistor)
        super(downloader, JusticeGovSk::Parsers::CriminalHearingParser.new, persistor)
      end
      
      protected
    
      def process(uri, content)
        super(uri, content)        


        
        @persistor.persist(@hearing)
      end
    end
  end
end
