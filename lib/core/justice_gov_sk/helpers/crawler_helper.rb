# encoding: utf-8

module JusticeGovSk
  module Helpers
    module CrawlerHelper
      def self.crawl_resources(*args)
        type    = args[:type].camelcase
        offset  = args[:offset].blank? ? 1 : args[:offset].to_i
        limit   = args[:limit].blank? ? nil : args[:limit].to_i
        
        agent = JusticeGovSk::Agents::ListAgent.new
        
        agent.wait_time            = nil
        agent.cache_load_and_store = false
        agent.cache_uri_to_path    = JusticeGovSk::Requests::URL.uri_to_path_lambda

        request = "JusticeGovSk::Requests::#{type}ListRequest".constantize.new
        
        if type == 'Judge'
          handler = JusticeGovSk::Crawlers::JudgeListCrawler.new agent

          handler.crawl_and_process(request, offset, limit)
        else
          handler = JusticeGovSk::Crawlers::ListCrawler.new agent
  
          downloader = Downloader.new
          persistor  = Persitor.new
  
          downloader.headers              = agent.headers
          downloader.data                 = {}
          downloader.wait_time            = nil
          downloader.cache_load_and_store = true
          downloader.cache_uri_to_path    = JusticeGovSk::Requests::URL.uri_to_path_lambda
  
          crawler = "JusticeGovSk::Crawlers::#{type}Crawler.new".constantize.new downloader, persistor
          
          handler.crawl_and_process(request, offset, limit) do |url|
            crawler.crawl url
          end
        end
      end
    end
  end
end
