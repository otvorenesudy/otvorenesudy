module JusticeGovSk
  class Crawler
    class List < JusticeGovSk::Crawler
      include Core::Crawler::List
      
      def initialize(downloader, parser = nil, persistor = nil)
        parser ||= JusticeGovSk::Parser::List.new

        super(downloader, parser, persistor)
      end
    end
  end
end
