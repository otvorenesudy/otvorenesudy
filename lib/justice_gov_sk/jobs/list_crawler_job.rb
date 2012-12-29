module JusticeGovSk
  module Jobs
    class ListCrawlerJob
      @queue = :list_crawlers
 
      # supported types: Court, Judge, CivilHearing, SpecialHearing, CriminalHearing, Decree
      def self.perform(type, options = {})
        type = type.to_s.camelcase.constantize
        
        options.symbolize_keys!
        
        raise "Offset not set #{options}" if options[:offset].nil?
        raise "Limit not set"  if options[:limit].nil?
        
        request, lister = JusticeGovSk::Helpers::CrawlerHelper.build_request_and_lister type, options
        
        if type == Judge
          JusticeGovSk::Helpers::CrawlerHelper.run_lister lister, request, options
        else
          JusticeGovSk::Helpers::CrawlerHelper.run_lister lister, request, options do
            crawler = JusticeGovSk::Helpers::CrawlerHelper.build_crawler type, options
            
            lister.crawl_and_process(request, options[:offset], options[:limit]) do |url|
              Resque.enqueue(JusticeGovSk::Jobs::CrawlerJob, type.name, url, options)
            end
          end
        end
      end
    end
  end
end
