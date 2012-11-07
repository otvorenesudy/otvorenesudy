module JusticeGovSk
  module Crawlers
    class CriminalHearingCrawler < HearingCrawler
      def initialize(downloader, persistor)
        super(downloader, JusticeGovSk::Parsers::CriminalHearingParser.new, persistor)
      end
      
      protected
    
      def process(uri, content)
        super(uri, content)

        judges(document)

        defendants(document)
        
        @persistor.persist(@hearing)
      end
      
      def judges(document)
      end
      
      def defendants(document)
      end
      
      def accusations(document)
      end
    end
  end
end
