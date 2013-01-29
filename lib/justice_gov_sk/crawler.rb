module JusticeGovSk
  class Crawler
    include Core::Crawler
    include Core::Factories
    include Core::Identify
    include Core::Injector
    include Core::Pluralize
    
    attr_accessor :options
    
    def initialize(options = {})
      @downloader = inject JusticeGovSk::Downloader
      @parser     = inject JusticeGovSk::Parser
      @persistor  = inject JusticeGovSk::Persistor
    end
  end
end
