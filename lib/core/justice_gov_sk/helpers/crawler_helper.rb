# encoding: utf-8

module JusticeGovSk
  module Helpers
    module CrawlerHelper
      # supported types: Court, Judge, CivilHearing, SpecialHearing, CriminalHearing, Decree
      def self.crawl_resources(type, offset, limit)
        type   = type.camelcase
        offset = offset.blank? ? 1 : offset.to_i
        limit  = limit.blank? ? nil : limit.to_i
        
        persistor = Persistor.new
        
        agent = JusticeGovSk::Agents::ListAgent.new
        
        agent.cache_load_and_store = false

        request = "JusticeGovSk::Requests::#{type}ListRequest".constantize.new
        
        if type == 'Judge'
          lister = JusticeGovSk::Crawlers::JudgeListCrawler.new agent, persistor

          lister.crawl_and_process(request, offset, limit)
        else
          lister = JusticeGovSk::Crawlers::ListCrawler.new agent
          
          lister.crawl_and_process(request, offset, limit) do |url|
            crawl_resource type, url
          end
        end
      end
      
      # supported types: Court, CivilHearing, SpecialHearing, CriminalHearing, Decree
      def self.crawl_resource(type, url)
        type = type.camelcase
        
        storage = "JusticeGovSk::Storages::#{type}Storage".constantize.new

        downloader = Downloader.new

        downloader.headers              = JusticeGovSk::Requests::URL.headers
        downloader.data                 = {}
        downloader.cache_load_and_store = true
        downloader.cache_root           = storage.root
        downloader.cache_binary         = storage.binary
        downloader.cache_distribute     = storage.distribute
        downloader.cache_uri_to_path    = JusticeGovSk::Requests::URL.url_to_path_lambda :html

        persistor = Persistor.new

        crawler = "JusticeGovSk::Crawlers::#{type}Crawler".constantize.new downloader, persistor
        
        crawler.crawl url
      end
    end
  end
end
