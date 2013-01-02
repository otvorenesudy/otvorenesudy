module JusticeGovSk
  class Crawler
    include Core::Crawler
    include Core::Factories
    include Core::Identify
    include Core::Injector
    include Core::Pluralize
    
    def initialize
      @downloader = inject JusticeGovSk::Downloader
      @parser     = inject JusticeGovSk::Parser
      @persistor  = inject JusticeGovSk::Persistor
    end
  end
end
