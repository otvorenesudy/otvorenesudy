module JusticeGovSk
  module Crawlers
    class JudgeListCrawler < JusticeGovSk::Crawlers::ListCrawler
      include Factories
      include Identify
      include Pluralize 
      
      def initialize(downloader, persistor)
        super(downloader, JusticeGovSk::Parsers::JudgeListParser.new, persistor)
      end
      
      def crawl(request)
        super(request) do |list|
          list.each do |item|
            puts item.inspect 
          end
        end
      end
    end
  end
end
