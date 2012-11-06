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
        
        @hearing.uri          = uri
        @hearing.document_uri = @parser.document_uri(document)
        @hearing.case_number  = @parser.case_number(document)
        @hearing.file_number  = @parser.file_number(document)
        @hearing.date         = @parser.date(document)
        @hearing.room         = @parser.room(document)
      
        type(document)
        section(document)
        subject(document)
        form(document)
      end
      
      def type(document)
      end
      
      def section(document)
      end
      
      def subject(document)
      end
      
      def form(document)
      end
    end
  end
end
