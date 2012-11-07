module JusticeGovSk
  module Crawlers
    class SpecialHearingCrawler < HearingCrawler
      def initialize(downloader, persistor)
        super(downloader, JusticeGovSk::Parsers::SpecialHearingParser.new, persistor)
      end
      
      protected
    
      def process(uri, content)
        super(uri, content)

        @hearing.commencement_date = @parser.commencement_date(document)
        @hearing.selfjudge         = @parser.selfjudge(document)
        
        chair_judge(document)
        
        defendant(document)
        
        @persistor.persist(@hearing)
      end
      
      def chair_judge(document)
      end
      
      def defendant(document)
      end
    end
  end
end
