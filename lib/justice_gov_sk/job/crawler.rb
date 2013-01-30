module JusticeGovSk
  module Job
    class Crawler
      @queue = :crawlers
      
      # supported types: CivilHearing, SpecialHearing, CriminalHearing, Decree
      def self.perform(type, url, options = {})
        type = type.to_s.constantize
        
        options.symbolize_keys!
        
        JusticeGovSk.crawl_resource type, url, options
      end
    end
  end
end
