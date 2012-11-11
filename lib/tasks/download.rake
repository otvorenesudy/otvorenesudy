# encoding: utf-8

namespace :download do
  task :cache, [:type, :offset, :limit] => :environment do |task, args|
    type    = args[:type].camelcase
    offset  = args[:offset].blank? ? 1 : args[:offset].to_i
    limit   = args[:limit].blank? ? nil : args[:limit].to_i
    
    agent = JusticeGovSk::Agents::ListAgent.new
    
    agent.wait_time            = nil
    agent.cache_load_and_store = false
    agent.cache_uri_to_path    = JusticeGovSk::Requests::URL.uri_to_path_lambda
    
    crawler = JusticeGovSk::Crawlers::ListCrawler.new agent
    request = "JusticeGovSk::Requests::#{type}ListRequest".constantize.new

    downloader = Downloader.new
    
    downloader.headers              = agent.headers
    downloader.data                 = {}
    downloader.wait_time            = nil
    downloader.cache_load_and_store = true
    downloader.cache_uri_to_path    = JusticeGovSk::Requests::URL.uri_to_path_lambda
    
    crawler.crawl_and_process(request, offset, limit) do |url|
      begin
        downloader.download url
      rescue Exception => e
        _, code = *e.to_s.match(/response code (\d+)/i)
              
        if code.to_i == 302
          puts "Redirect returned for #{url}, rejected."
        else
          raise e
        end
      end
    end
  end  
end
