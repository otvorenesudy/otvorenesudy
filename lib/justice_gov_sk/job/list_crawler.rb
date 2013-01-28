module JusticeGovSk
  module Job
    class ListCrawler
      @queue = :listers
 
      # supported types: Court, Judge, CivilHearing, SpecialHearing, CriminalHearing, Decree
      def self.perform(type, options = {})
        type = type.to_s.camelcase.constantize
        
        options.symbolize_keys!
        
        raise "Offset not set" if options[:offset].nil?
        raise "Limit not set" if options[:limit].nil?
        
        request, lister = JusticeGovSk.build_request_and_lister type, options
        
        # TODO fix
        if type == Judge
          JusticeGovSk.run_lister lister, request, options
        else
          JusticeGovSk.run_lister lister, request, options do
            crawler = JusticeGovSk.build_crawler type, options
            
            lister.crawl(request, options[:offset], options[:limit]) do |url|
              Resque.enqueue(JusticeGovSk::Job::Crawler, type.name, url, options)
            end
          end
        end
      end
    end
  end
end
