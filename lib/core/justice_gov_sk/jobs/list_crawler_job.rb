module JusticeGovSk
  module Jobs
    class ListCrawlerJob
      @queue = :list_crawlers
 
      def self.perform(type, offset, limit, decree_form)
        type = type.camelcase

        agent     = JusticeGovSk::Agents::ListAgent.new
        persistor = Persistor.new
        request   = "JusticeGovSk::Requests::#{type}ListRequest".constantize.new
        
        request.decree_form = decree_form

        if type == 'Judge'
          lister = JusticeGovSk::Crawlers::JudgeListCrawler.new agent, persistor

          agent.cache_load_and_store = false
          lister.crawl_and_process(request, offset, limit)
        else
          lister    = JusticeGovSk::Crawlers::ListCrawler.new agent
          storage   = "JusticeGovSk::Storages::#{type}Storage".constantize.new
          
          agent.cache_load_and_store = false
          lister.crawl_and_process(request, offset, limit) do |url|
            Resque.enqueue(JusticeGovSk::Jobs::CrawlerJob, type, url, decree_form)
          end
        end
      end
    end
  end
end
