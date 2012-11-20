module JusticeGovSk
  module Jobs
    class ListCrawlerJob
      @queue = :list_crawlers
 
      def self.perform(type, offset, limit)
        type = type.camelcase

        agent     = JusticeGovSk::Agents::ListAgent.new
        persistor = Persistor.new
        request   = "JusticeGovSk::Requests::#{type}ListRequest".constantize.new
        
        if type == 'Judge'
          lister = JusticeGovSk::Crawlers::JudgeListCrawler.new agent, persistor

          lister.crawl_and_process(request, offset, limit)
        else
          lister    = JusticeGovSk::Crawlers::ListCrawler.new agent
          storage   = "JusticeGovSk::Storages::#{type}Storage".constantize.new
          
          lister.crawl_and_process(request, offset, limit) do |url|
            puts "#{self.name}: enqueueing #{url}"
            Resque.enqueue(JusticeGovSk::Jobs::CrawlerJob, type, url)
          end
        end
      end
    end
  end
end
