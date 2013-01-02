module JusticeGovSk
  class Crawler
    class List < JusticeGovSk::Crawler
      include Core::Crawler::List
      
      def initialize
        @downloader = inject JusticeGovSk::Agent
        @parser     = inject JusticeGovSk::Parser
        @persistor  = inject JusticeGovSk::Persistor
      end
    end
  end
end
