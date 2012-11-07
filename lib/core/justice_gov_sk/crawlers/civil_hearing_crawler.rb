module JusticeGovSk
  module Crawlers
    class CivilHearingCrawler < HearingCrawler
      def initialize(downloader, persistor)
        super(downloader, JusticeGovSk::Parsers::CivilHearingParser.new, persistor)
      end
      
      protected
    
      def process(uri, content)
        document = preprocess(uri, content)

        @hearing.special_type = @parser.special_type(document)
        
        judges(document)
        
        proposers(document)
        opponents(document)
        
        @persistor.persist(@hearing)
      end
      
      def judges(document)
      end
        
      def proposers(document)
      end

      def opponents(document)
      end
    end
  end
end
