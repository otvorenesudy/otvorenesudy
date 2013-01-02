module JusticeGovSk
  class Crawler
    class List < JusticeGovSk::Crawler
      include Core::Crawler::List
      
      def initialize(options = {})
        type = options[:type]
        
        @downloader = inject JusticeGovSk::Agent,     implementation: type, suffix: :List
        @parser     = inject JusticeGovSk::Parser,    implementation: type, suffix: :List
        @persistor  = inject JusticeGovSk::Persistor, implementation: type, suffix: :List
      end
    end
  end
end
