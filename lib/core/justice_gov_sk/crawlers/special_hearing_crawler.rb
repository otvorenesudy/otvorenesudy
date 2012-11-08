module JusticeGovSk
  module Crawlers
    class SpecialHearingCrawler < HearingCrawler
      def initialize(downloader, persistor)
        super(downloader, JusticeGovSk::Parsers::SpecialHearingParser.new, persistor)
      end
      
      protected
    
      def process(uri, content)
        document = preprocess(uri, content)

        @hearing.commencement_date = @parser.commencement_date(document)
        @hearing.selfjudge         = @parser.selfjudge(document)
        
        chair_judge(document)
        
        defendant(document)
        
        @persistor.persist(@hearing)
      end
      
      def chair_judge(document)
        name = @parser.chair_judge(document)
        
        unless name.nil?
          @hearing.chair_judge = judge_factory.find(name)
        end
      end
      
      def defendant(document)
        name = @parser.defendant(document)
        
        unless name.nil?
          defendant = defendant_factory.find_or_create(@hearing.id, name)
          
          defendant.hearing = @hearing
          defendant.name    = name
          
          @persistor.persist(defendant) if defendant.id.nil?
        end
      end
    end
  end
end
