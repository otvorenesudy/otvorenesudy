require 'resque/tasks'

namespace :justicegovsk do 
  namespace :jobs do 
    
    desc "Enqueues jobs for crawling lists"
    task :list_crawlers, [:type, :decree_form] => :environment do |_, args|
      type        = args[:type]
      decree_form = DecreeForm.find_by_value(args[:decree_form])

      decree_form = decree_form ? decree_form.code : nil

      raise "No type provided" unless type
     
      agent     = JusticeGovSk::Agents::ListAgent.new
      persistor = Persistor.new
      request   = "JusticeGovSk::Requests::#{type}ListRequest".constantize.new

      if type == 'Judge'
        #lister = JusticeGovSk::Crawlers::JudgeListCrawler.new agent, persistor

        #agent.cache_load_and_store = false

        #lister.crawl_and_process(request, 1, 1)
      else
        lister    = JusticeGovSk::Crawlers::ListCrawler.new agent
        storage   = "JusticeGovSk::Storages::#{type}Storage".constantize.new

        agent.cache_load_and_store = false

        lister.crawl_and_process(request, 1, 1)
      end

      from  = 1
      to    = lister.pages

      (from..to).each do |page|
        Resque.enqueue(JusticeGovSk::Jobs::ListCrawlerJob, type, page, 1, decree_form)
      end
    end
  
  end
end

