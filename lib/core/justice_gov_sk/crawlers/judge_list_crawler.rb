module JusticeGovSk
  module Crawlers
    class JudgeListCrawler < JusticeGovSk::Crawlers::ListCrawler
      include Factories
      include Identify
      include Pluralize 
      
      def initialize(downloader, persistor)
        super(downloader, JusticeGovSk::Parsers::JudgeListParser.new, persistor)
      end
      
    end
  end
end
