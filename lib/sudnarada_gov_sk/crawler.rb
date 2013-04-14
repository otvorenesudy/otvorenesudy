module SudnaradaGovSk
  class Crawler
    include Core::Crawler
    include Core::Crawler::Helper
    include Core::Factories
    include Core::Identify
    include Core::Injector
    include Core::Pluralize
    
    def initialize(options = {})
      @downloader = inject SudnaradaGovSk::Agent
      @parser     = inject SudnaradaGovSk::Parser
      @persistor  = inject SudnaradaGovSk::Persistor
    end
  end
end
