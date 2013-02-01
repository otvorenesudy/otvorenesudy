# encoding: utf-8

# TODO
# consider distinguishing between pages and documents everywhere, like in storages
# example: Downloader::CourtPage, Parser::CourtPage? 
# also consider storage/page/decree.rb vs. storage/decree_page.rb 
# or remove _page suffix from storages? and leave only _document (and _list)

module JusticeGovSk
  module Base
    include Core::Output
    
    # supported types: Court, CivilHearing, CriminalHearing, SpecialHearing, Decree
    def download_pages(type, options = {})
      offset = options[:offset].blank? ? 1 : options[:offset].to_i
      limit  = options[:limit].blank? ? nil : options[:limit].to_i
      
      request, lister = build_request_and_lister type, options
      
      downloader = inject JusticeGovSk::Downloader, implementation: type
      
      run_lister lister, request, options do
        lister.crawl(request, offset, limit) do |url|
          call lambda { downloader.download url }, options
        end
      end
    end  
    
    # supported types: Decree
    def download_documents(type, options = {})
      storage = JusticeGovSk::Storage::DecreePage.instance
      request = JusticeGovSk::Request::Document.new
      agent   = JusticeGovSk::Agent::DecreeDocument.new
      
      extend JusticeGovSk::Helper::ContentValidator
      
      storage.each do |entry, bucket|
        path = File.join storage.root, bucket, entry
        
        print "Reading #{path} ... "
        
        content = File.read path
        
        puts "done (#{content.size} bytes)"
        
        request.url = entry.sub(/decree/, 'Stranky/Sudne-rozhodnutia/Sudne-rozhodnutie-detail')
        request.url = request.url.sub(/\.html/, '')
        request.url = "#{JusticeGovSk::URL.base}/#{request.url}"
        
        call lambda { agent.download request }, options
        
        valid_content? agent.storage.path(entry.sub(/html\z/, 'pdf')), :decree_pdf
        
        puts
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
  
    def build_request(type, options = {})
      args = build_args type, options
      
      inject JusticeGovSk::Request, implementation: type, suffix: :List, args: args
    end
    
    def build_lister(type, options = {})
      args = build_args type, options
      
      inject JusticeGovSk::Crawler, implementation: type, suffix: :List, args: args
    end
    
    def build_request_and_lister(type, options = {})
      request = build_request type, options
      lister  = build_lister  type, options
      
      return request, lister
    end
    
    def build_crawler(type, options = {})
      args = build_args type, options
      
      inject JusticeGovSk::Crawler, implementation: type, args: args
    end      
    
    def run_lister(lister, request, options = {}, &block)
      offset = options[:offset].blank? ? 1 : options[:offset].to_i
      limit  = options[:limit].blank? ? nil : options[:limit].to_i
      block  = lambda { lister.crawl request, offset, limit } unless block_given?
      
      call block, options
    end
    
    def run_crawler(crawler, url, options = {}, &block)
      block = lambda { crawler.crawl url } unless block_given?
      
      call block, options
    end
    
    def run_workers(type, options = {})
      request, lister = build_request_and_lister type, options
      
      run_lister lister, request, options do
        puts "Running list crawler to obtain page count."
        
        lister.crawl(request, 1, 1) {}
      end
      
      puts  "Running job builder."

      options = options.to_hash.merge! limit: 1
      
      1.upto lister.pages do |page|
        options.merge!(offset: page)
        
        puts "Enqueing job for page #{page}, using #{pack options}."
        
        Resque.enqueue(JusticeGovSk::Job::ListCrawler, type.name, options)
      end
      
      puts "finished (#{lister.pages} jobs)"
    end
    
    private
    
    include Core::Injector
    
    def build_args(type, options = {})
      options.to_hash.merge type: type
    end
    
    def call(block, options = {})
      safe = options[:safe].nil? ? true : options[:safe]
      
      puts "Setting #{pack options}"
      
      if safe
        block.call
      else
        begin
          block.call
        rescue Exception => e
          _, code = *e.to_s.match(/response code (\d+)/i)
          
          case code.to_i
          when 302
            puts "aborted (redirect returned)"
          when 403
            puts "aborted (forbidden)"
          when 404
            puts "aborted (not found)"
          when 500
            puts "aborted (internal server error)"
          else
            raise e
          end
        end
      end
    end
    
    def pack(options = {})
      options.map { |k, v| "#{k}: #{v.is_a?(Class) ? v.name : v}" }.join(', ') || 'nothing'
    end
  end
end
