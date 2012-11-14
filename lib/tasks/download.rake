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
    downloader.cache_load_and_store = true
    downloader.cache_file_extension = :html
    downloader.cache_uri_to_path    = agent.cache_uri_to_path
    
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

  task :documents, [:type] => :environment do |task, args|
    type = args[:type].camelcase
    
    request = JusticeGovSk::Requests::DocumentRequest.new
    agent   = JusticeGovSk::Agents::DocumentAgent.new
    
    agent.cache_root           = JusticeGovSk::Documents::URI.base
    agent.cache_binary         = true
    agent.cache_load_and_store = true
    agent.cache_file_extension = :pdf
    agent.cache_uri_to_path    = JusticeGovSk::Requests::URL.uri_to_path_lambda

    dir = Dir.new(File.join Agent.new.cache_root, type.downcase.pluralize)

    FileUtils.mkpath dir
    
    dir.each do |file|
      unless file.starts_with? '.'
        path = File.join dir, file
        
        print "Reading file #{path} ... "
        
        content = File.read path
        
        puts "done (#{content.size} bytes)"
        
        request.url = file.sub(/decree/, 'Stranky/Sudne-rozhodnutia/Sudne-rozhodnutie-detail')
        request.url = request.url.sub(/\.html/, '')
        request.url = "#{JusticeGovSk::Requests::URL.base}/#{request.url}"
        
        agent.download request
        
        puts
      end
    end
    
    puts "finished"
  end
end
