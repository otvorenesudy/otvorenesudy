# encoding: utf-8

namespace :download do
  task :hearings => :environment do
    d = Downloader.new
    
    d.wait_time         = nil
    d.cache_load        = false
    d.cache_root        = '/media/external-ext4/cache'
    d.cache_uri_to_path = JusticeGovSk::Requests::URL.uri_to_path_lambda
    
    c = JusticeGovSk::Crawlers::ListCrawler.new d
    
    r = JusticeGovSk::Requests::CivilHearingListRequest.new
    #r = JusticeGovSk::Requests::CriminalHearingListRequest.new
    #r = JusticeGovSk::Requests::SpecialHearingListRequest.new
    
    c.crawl_and_process(r) do |url|
       d.headers = r.headers
       d.data    = {}
       
       d.download url
    end
  end  
end
