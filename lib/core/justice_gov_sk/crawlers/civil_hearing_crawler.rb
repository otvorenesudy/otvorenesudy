module JusticeGovSk
  module Crawlers
    class CivilHearingCrawler < HearingCrawler
      def initialize(downloader, persistor)
        super(downloader, JusticeGovSk::Parsers::CivilHearingParser.new, persistor)
      end
      
      protected
    
      def process(uri, content)
        super(uri, content)        


        
        @persistor.persist(@hearing)
      end
    end
  end
end
