module JusticeGovSk
  class Crawler
    include Core::Crawler
    include Core::Crawler::Helper
    include Core::Factories
    include Core::Identify
    include Core::Injector
    include Core::Pluralize
    
    def initialize(options = {})
      @downloader = inject JusticeGovSk::Downloader
      @parser     = inject JusticeGovSk::Parser
      @persistor  = inject JusticeGovSk::Persistor
    end
  end
end
