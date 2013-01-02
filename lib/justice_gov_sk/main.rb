# encoding: utf-8

# TODO refactor all helpers to be not static, like in app/helpers

# TODO add filter option: crawl only data not in DB / update DB

# TODO refactor core:
#
# do not mix variables:
# uri -> request
# content -> ? (resource?)
#
# remove subclass specific functionality from superclass,
# example: mv ListRequest.decree_form -> DecreeListRequest
# remove lines like: if type < Hearing

module JusticeGovSk
  module Main
    # TODO refactor downloaders
    
    # supported types: Court, CivilHearing, CriminalHearing, SpecialHearing, Decree
    def download_pages(type, options = {})
      type    = type.camelcase.split(/\:/).first
      offset  = options[:offset].blank? ? 1 : options[:offset].to_i
      limit   = options[:limit].blank? ? nil : options[:limit].to_i
      
      agent = JusticeGovSk::Agents::ListAgent.new
      
      agent.cache_load_and_store = false
      
      request = "JusticeGovSk::Request::#{type}List".constantize.new
      storage = "JusticeGovSk::Storage::#{type}Page".constantize.instance    
      crawler = JusticeGovSk::Crawler::ListCrawler.new agent
      
      if request.is_a? JusticeGovSk::Request::DecreeList
        request.decree_form = args[:type].scan(/\:(\w)/)
        abort "Decree form not set" if request.decree_form.blank? 
      end
      
      downloader = Downloader.new
      
      downloader.headers              = {} #JusticeGovSk::Requests::URL.headers
      downloader.data                 = {}
      downloader.cache_load_and_store = true
      downloader.cache_root           = storage.root
      downloader.cache_binary         = storage.binary
      downloader.cache_distribute     = storage.distribute
      downloader.cache_uri_to_path    = JusticeGovSk::URL.url_to_path_lambda :html
      
      crawler.crawl(request, offset, limit) do |url|
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
    def download_documents(type)
      type = type.camelcase
      
      request = JusticeGovSk::Request::Document.new
      storage = JusticeGovSk::Storage::Document.instance
      agent   = JusticeGovSk::Agent::Document.new
      
      agent.cache_load_and_store = true
      agent.cache_root           = File.join storage.root, type.downcase.pluralize
      agent.cache_binary         = storage.binary
      agent.cache_distribute     = storage.distribute
      agent.cache_uri_to_path    = JusticeGovSk::URL.url_to_path_lambda :pdf
      
      dir = File.join JusticeGovSk::Storage::DecreePage.instance.root
      
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
          request.url = "#{JusticeGovSk::URL.base}/#{request.url}"
          
          begin
            agent.download request
          rescue Exception => e
            # silently ignore all persistent errors, mostly timeouts
          end
          
          puts
        end
      end
    end
    
    # supported types: Court, Judge, CivilHearing, SpecialHearing, CriminalHearing, Decree
    def crawl_resources(type, options = {})
      request, lister = build_request_and_lister type, options
      
      run_lister lister, request, options
    end
    
    # supported types: Court, CivilHearing, SpecialHearing, CriminalHearing, Decree
    def crawl_resource(type, url, options = {})
      crawler = build_crawler type, options
      
      run_crawler crawler, url, options
    end
  
    # supported types: Court, Judge, CivilHearing, SpecialHearing, CriminalHearing, Decree
    def build_request(type, options = {})
      type = resolve type
      
      request = "JusticeGovSk::Request::#{type.name}List".constantize.new
      
      request.per_page = options[:per_page] unless options[:per_page].nil?
      request.page     = options[:page]     unless options[:page].nil? 
      
      if type < Hearing
        request.include_old_hearings = options[:include_old_hearings] unless options[:include_old_hearings].nil?
      elsif type < Decree
        request.decree_form = options[:decree_form] unless options[:decree_form].nil?
        
        raise "Unknown decree form #{request.decree_form}" unless DecreeForm.find_by_code(request.decree_form)
      end
      
      request
    end
    
    # supported types: Court, Judge, CivilHearing, SpecialHearing, CriminalHearing, Decree
    def build_lister(type, options = {})
      type = resolve type
  
      agent = JusticeGovSk::Agent::List.new
      
      agent.cache_load_and_store = false
      
      if options[:generic].blank?
        if type == Judge
          persistor = JusticeGovSk::Persistor.new
        
          return JusticeGovSk::Crawler::JudgeList.new agent, persistor
        end
      end
      
      JusticeGovSk::Crawler::List.new agent
    end
    
    # supported types: Court, Judge, CivilHearing, SpecialHearing, CriminalHearing, Decree
    def build_request_and_lister(type, options = {})
      request = build_request type, options
      lister  = build_lister  type, options
      
      return request, lister
    end
    
    # supported types: Court, CivilHearing, SpecialHearing, CriminalHearing, Decree
    def build_crawler(type, options = {})
      type = resolve type
  
      storage = "JusticeGovSk::Storage::#{type.name}Page".constantize.instance
  
      downloader = Downloader.new
  
      downloader.headers              = JusticeGovSk::Request.headers
      downloader.data                 = {}
      downloader.cache_load_and_store = true
      downloader.cache_root           = storage.root
      downloader.cache_binary         = storage.binary
      downloader.cache_distribute     = storage.distribute
      downloader.cache_uri_to_path    = JusticeGovSk::URL.url_to_path_lambda :html
  
      persistor = Persistor.new
  
      crawler = "JusticeGovSk::Crawler::#{type.name}".constantize.new downloader, persistor
      
      crawler.form_code = options[:decree_form] if type == Decree
      
      crawler
    end      
    
    def run_lister(lister, request, options = {}, &block)
      offset = options[:offset].blank? ? 1 : options[:offset].to_i
      limit  = options[:limit].blank? ? nil : options[:limit].to_i
      
      _, type = *request.class.name.match(/JusticeGovSk::Request::(.+)List/)
      
      type = type.constantize
  
      if options[:generic].blank? && type == Judge
        raise "Unable to use block" if block_given?
        
        block = lambda do
          lister.crawl(request, offset, limit)
        end
      else
        unless block_given?
          crawler = build_crawler type, options
          
          block = lambda do
            lister.crawl(request, offset, limit) do |url|
              run_crawler crawler, url, options
            end
          end
        end
      end
      
      call block, options
    end
    
    def run_crawler(crawler, url, options = {}, &block)
      block = lambda { crawler.crawl url } unless block_given?
      
      call block, options
    end
    
    # TODO refactor work
    
    # supported types: Court, Judge, CivilHearing, SpecialHearing, CriminalHearing, Decree
    def work(type, options = {})
      type = resolve type
      
      request_and_lister_options = { generic: true, safe: true }
      request_and_lister_options.merge! decree_form: options[:decree_form] if type == Decree
      
      request, lister = build_request_and_lister type, request_and_lister_options
      
      # TODO rm
      puts "#{request}"
      puts "#{lister}"
      
      run_lister lister, request, request_and_lister_options do
        lister.crawl request
      end
      
      job_options = { safe: true, limit: 1 }
      job_options.merge! decree_form: options[:decree_form] if type == Decree
  
      1.upto lister.pages do |page|
        Resque.enqueue(JusticeGovSk::Job::ListCrawler, type.name, job_options.merge(offset: page))
      end
    end
    
    private
    
    def resolve(type)
      type.is_a?(Class) ? type : type.to_s.camelcase.constantize
    end
    
    def call(block, options = {})
      safe = options[:safe].nil? ? true : options[:safe]
      
      if safe
        block.call
      else
        begin
          block.call
        rescue Exception => e
          _, code = *e.to_s.match(/response code (\d+)/i)
          
          case code.to_i
          when 302
            puts "failed (redirect returned)"
          when 500
            puts "failed (internal server error)"
          else
            raise e
          end
        end
      end
    end    
  end
end
