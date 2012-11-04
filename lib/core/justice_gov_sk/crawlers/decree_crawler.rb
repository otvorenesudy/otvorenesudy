module JusticeGovSk
  module Crawlers
    class DecreeCrawler < Crawler
      include Factories
      include Identify
      include Pluralize 
      
      def initialize(downloader, persistor)
        super(downloader, JusticeGovSk::Parsers::DecreeParser.new, persistor)
      end
      
      protected
    
      def process(uri, content)
        document = @parser.parse(content)
                
        @decree = decree_factory.find_or_create(uri)
        

        
        @persistor.persist(@decree)
      end
    end
  end
end
