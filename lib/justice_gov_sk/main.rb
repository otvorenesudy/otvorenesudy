# encoding: utf-8

# TODO add filter option: crawl only data not in DB / update DB

# TODO refactor core:
# remove subclass specific functionality from superclass,
# example: mv ListRequest.decree_form -> DecreeListRequest
# remove lines like: if type < Hearing

# TODO
# consider distinguishing between pages and documents everywhere, like in storages
# example: Downloader::CourtPage, Parser::CourtPage? 
# also consider storage/page/decree.rb vs. storage/decree_page.rb 
# or remove _page suffix from storages? and leave only _document (and _list)

# TODO add InstanceSupplier + InstanceWithJustValueSupplier
# (useful for creating / finding = processing: DecreeNature, HearingSection,
# HearingSubject, ...) => benefit: much more simplified crawlers :)

module JusticeGovSk
  module Main
    # supported types: Court, CivilHearing, CriminalHearing, SpecialHearing, Decree
    def download_pages(type, options = {})
      offset = options[:offset].blank? ? 1 : options[:offset].to_i
      limit  = options[:limit].blank? ? nil : options[:limit].to_i
      
      request, lister = build_request_and_lister type, options
      
      downloader = inject JusticeGovSk::Downloader, implementation: type
      
      run_lister lister, request, options do
        lister.crawl(request) do |url|
          downloader.download url
        end
      end
    end  
    
    # supported types: Decree
    def download_documents(type, options = {})
      source  = File.join JusticeGovSk::Storage::DecreePage.instance.root
      request = JusticeGovSk::Request::Document.new
      agent   = JusticeGovSk::Agent::DecreeDocument.new
      
      Dir.foreach(source) do |bucket|
        next if bucket.start_with? '.'
        
        Dir.foreach(File.join source, bucket) do |file|
          next if file.start_with? '.'
          
          path = File.join source, bucket, file
          
          print "Reading #{path} ... "
          
          content = File.read path
          
          puts "done (#{content.size} bytes)"
          
          request.url = file.sub(/decree/, 'Stranky/Sudne-rozhodnutia/Sudne-rozhodnutie-detail')
          request.url = request.url.sub(/\.html/, '')
          request.url = "#{JusticeGovSk::URL.base}/#{request.url}"
          
          call lambda { agent.download request }, options
          
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
      inject JusticeGovSk::Request, implementation: type, suffix: :List, args: options
    end
    
    # supported types: Court, Judge, CivilHearing, SpecialHearing, CriminalHearing, Decree
    def build_lister(type, options = {})
      inject JusticeGovSk::Crawler, implementation: type, suffix: :List, args: { type: type }
    end
    
    # supported types: Court, Judge, CivilHearing, SpecialHearing, CriminalHearing, Decree
    def build_request_and_lister(type, options = {})
      request = build_request type, options
      lister  = build_lister  type, options
      
      return request, lister
    end
    
    # supported types: Court, CivilHearing, SpecialHearing, CriminalHearing, Decree
    def build_crawler(type, options = {})
      inject JusticeGovSk::Crawler, implementation: type, args: options
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
        lister.crawl(request)
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
