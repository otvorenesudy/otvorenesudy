# encoding: utf-8

namespace :download do
  task :cache, [:type, :offset, :limit] => :environment do |task, args|
    request = "JusticeGovSk::Requests::#{args[:type]}ListRequest".constantize.new
    offset  = args[:offset].blank? ? 1 : args[:offset].to_i
    limit   = args[:limit].blank? ? nil : args[:limit].to_i
    
    handler = Downloader.new
    
    handler.wait_time            = nil
    handler.cache_load_and_store = false
    handler.cache_uri_to_path    = JusticeGovSk::Requests::URL.uri_to_path_lambda
    
    crawler = JusticeGovSk::Crawlers::ListCrawler.new handler

    downloader = handler.clone
    
    downloader.headers              = request.headers
    downloader.data                 = {}
    downloader.cache_load_and_store = true
    
    crawler.crawl_and_process(request, offset, limit) do |url|
       downloader.download url
    end
  end  
end
