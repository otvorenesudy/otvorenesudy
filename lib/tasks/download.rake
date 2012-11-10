# encoding: utf-8

namespace :download do
  task :cache, [:type, :offset, :limit] => :environment do |task, args|
















    z= JusticeGovSk::Agents::ListAgent.new
        z.wait_time            = nil
    z.cache_load_and_store = false
    q= JusticeGovSk::Requests::DecreeListRequest.new
    
    q.page =3500

    x = z.download q
    
    File.open('/media/external-ext4/cache/xxxx.html', 'w:utf-8') do |file|
      file.write x.content.force_encoding('utf-8')
      file.flush
    end
















    type    = args[:type].camelcase
    offset  = args[:offset].blank? ? 1 : args[:offset].to_i
    limit   = args[:limit].blank? ? nil : args[:limit].to_i
    
    agent = Agent.new
    
    agent.wait_time            = nil
    agent.cache_load_and_store = false
    agent.cache_uri_to_path    = JusticeGovSk::Requests::URL.uri_to_path_lambda
    
    crawler = JusticeGovSk::Crawlers::ListCrawler.new agent
    request = "JusticeGovSk::Requests::#{type}ListRequest".constantize.new

    downloader = Downloader.new
    
    downloader.headers              = agent.headers
    downloader.data                 = {}
    downloader.wait_time            = nil
    downloader.cache_load_and_store = false
    downloader.cache_uri_to_path    = JusticeGovSk::Requests::URL.uri_to_path_lambda


    
    #crawler.crawl request
    
    exit
    
    crawler.crawl_and_process(request, offset, limit) do |url|
       downloader.download url
    end
  end  
end
