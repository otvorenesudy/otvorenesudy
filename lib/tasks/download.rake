# encoding: utf-8

namespace :download do
  task :hearings => :environment do
    handler = Downloader.new
    
    handler.wait_time         = nil
    handler.cache_load        = false
    handler.cache_store       = false
    handler.cache_root        = '/media/external-ext4/cache'
    handler.cache_uri_to_path = JusticeGovSk::Requests::URL.uri_to_path_lambda
    
    crawler = JusticeGovSk::Crawlers::ListCrawler.new handler
    
    request = JusticeGovSk::Requests::CivilHearingListRequest.new
    #request = JusticeGovSk::Requests::CriminalHearingListRequest.new
    #request = JusticeGovSk::Requests::SpecialHearingListRequest.new

    downloader = handler.clone
    
    downloader.headers     = request.headers
    downloader.data        = {}
    downloader.cache_load  = true
    downloader.cache_store = true
    
    crawler.crawl_and_process(request) do |url|
       downloader.download url
    end
  end  
end
