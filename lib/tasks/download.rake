# encoding: utf-8

namespace :download do 
  # supported types: Court, CivilHearing, CriminalHearing, SpecialHearing, Decree
  task :pages, [:type, :offset, :limit] => :environment do |task, args|
    type    = args[:type].camelcase
    offset  = args[:offset].blank? ? 1 : args[:offset].to_i
    limit   = args[:limit].blank? ? nil : args[:limit].to_i
    
    agent = JusticeGovSk::Agents::ListAgent.new
    
    agent.cache_load_and_store = false

    request = "JusticeGovSk::Requests::#{type}ListRequest".constantize.new
    storage = "JusticeGovSk::Storages::#{type}Storage".constantize.new    
    crawler = JusticeGovSk::Crawlers::ListCrawler.new agent

    downloader = Downloader.new
    
    downloader.headers              = {} #JusticeGovSk::Requests::URL.headers
    downloader.data                 = {}
    downloader.cache_load_and_store = true
    downloader.cache_root           = storage.root
    downloader.cache_binary         = storage.binary
    downloader.cache_distribute     = storage.distribute
    downloader.cache_uri_to_path    = JusticeGovSk::Requests::URL.url_to_path_lambda :html
    
    crawler.crawl_and_process(request, offset, limit) do |url|
      begin
        downloader.download url
      rescue Exception => e
        _, code = *e.to_s.match(/response code (\d+)/i)

        case code.to_i
        when 302 
          puts "Redirect returned for #{url}, rejected."
        when 500
          puts "Internal server error for #{url}, rejected."
        else
          raise e
        end
      end
    end
  end  

  # supported types: Decree
  task :documents, [:type] => :environment do |task, args|
    type = args[:type].camelcase
    
    request = JusticeGovSk::Requests::DocumentRequest.new
    storage = JusticeGovSk::Storages::DocumentStorage.new
    agent   = JusticeGovSk::Agents::DocumentAgent.new
    
    agent.cache_load_and_store = true
    agent.cache_root           = File.join storage.root, type.downcase.pluralize
    agent.cache_binary         = storage.binary
    agent.cache_distribute     = storage.distribute
    agent.cache_uri_to_path    = JusticeGovSk::Requests::URL.url_to_path_lambda :pdf

    dir = File.join JusticeGovSk::Storages::DecreeStorage.new.root

    FileUtils.mkpath dir unless Dir.exists? dir

    Dir.foreach(dir) do |bucket|
      next if bucket.start_with? '.'
      
      Dir.foreach(File.join dir, bucket) do |file|
        next if file.start_with? '.'
        
        path = File.join dir, bucket, file
        
        print "Reading #{path} ... "
        
        content = File.read path
        
        puts "done (#{content.size} bytes)"
        
        request.url = file.sub(/decree/, 'Stranky/Sudne-rozhodnutia/Sudne-rozhodnutie-detail')
        request.url = request.url.sub(/\.html/, '')
        request.url = "#{JusticeGovSk::Requests::URL.base}/#{request.url}"
        
        begin
          agent.download request
        rescue Exception => e
          # silently ignore all persistent errors, mostly timeouts
        end
        
        puts
      end
    end
  end
end
