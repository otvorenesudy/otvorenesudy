# encoding: utf-8

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

# TODO
# consider distinguishing between pages and documents everywhere, like in storages
# example: Downloader::CourtPage, Parser::CourtPage? 
# also consider storage/page/decree.rb vs. storage/decree_page.rb 
# or remove _page suffix from storages? and leave only _document (and _list)

module JusticeGovSk
  module Main
    # TODO refactor downloaders
    
    # supported types: Court, CivilHearing, CriminalHearing, SpecialHearing, Decree
    def download_pages(type, options = {})
      offset = options[:offset].blank? ? 1 : options[:offset].to_i
      limit  = options[:limit].blank? ? nil : options[:limit].to_i
      
      request, lister = build_request_and_lister type, options
      
      # TODO refactor
      if request.is_a? JusticeGovSk::Request::DecreeList
        request.decree_form = args[:type].scan(/\:(\w)/)
        abort "Decree form not set" if request.decree_form.blank? 
      end
      
      downloader = inject JusticeGovSk::Downloader, implementation: type
      
      run_lister lister, request, options do |url|
        downloader.download url
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
      
      request = inject JusticeGovSk::Request, implementation: type, suffix: :List
      
      request.per_page = options[:per_page] unless options[:per_page].nil?
      request.page     = options[:page]     unless options[:page].nil? 

      # TODO refactor  
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
      inject JusticeGovSk::Crawler, implementation: type, suffix: :List
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
  
      crawler = inject JusticeGovSk::Crawler, implementation: type

      # TODO refactor      
      crawler.form_code = options[:decree_form] if type == Decree
      
      crawler
    end      
    
    def run_lister(lister, request, options = {}, &block)
      offset = options[:offset].blank? ? 1 : options[:offset].to_i
      limit  = options[:limit].blank? ? nil : options[:limit].to_i
      
      _, type = *request.class.name.match(/JusticeGovSk::Request::(.+)List/)
      
      type = type.constantize
      
      # TODO refactor
      if type == Judge
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
    
    # supported types: Court, Judge, CivilHearing, SpecialHearing, CriminalHearing, Decree
    def run_workers(type, options = {})
      request, lister = build_request_and_lister type, options
      
      run_lister lister, request, options do
        lister.crawl request
      end
      
      options.merge! limit: 1
      
      1.upto lister.pages do |page|
        Resque.enqueue(JusticeGovSk::Job::ListCrawler, type.name, options.merge(offset: page))
      end
    end
    
    private
    
    include Core::Injector
    
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
