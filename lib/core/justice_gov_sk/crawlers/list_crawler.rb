module JusticeGovSk
  module Crawlers
    class ListCrawler < Crawler
      include Pluralize
      
      attr_reader :page,
                  :per_page,
                  :pages,
                  :next_page
      
      def initialize(downloader)
        super(downloader, JusticeGovSk::Parsers::ListParser.new, nil)
    
        @page      = nil
        @pages     = nil
        @per_page  = nil
        @next_page = nil
      end
          
      def crawl(request)
        introduce
        puts "Request #{request.class.name} on page #{request.page} of #{@pages || '?'}, max. #{pluralize request.per_page, 'item'} per page."
        
        list = []
        
        puts "XXX #{request.per_page}"
        puts "XXX #{request.page}"
        
        content  = @downloader.download(request)
        document = @parser.parse(content)
        
        @page      = @parser.page(document)
        @pages     = @parser.pages(document)
        @per_page  = @parser.per_page(document)
        @next_page = @parser.next_page(document)
        
        list = @parser.list(document)
    
        puts "done (page #{@page} of #{@pages}, #{pluralize list.count, 'item'}, next page #{@next_page || 'N/A'})"
        
        list
      end
      
      def crawl_and_process(request, offset = 1, limit = nil, &block)
        request.page = offset
        
        loop do
          unless limit.nil?
            limit -= 1
            
            break if limit < 0
          end
          
          list = crawl request
          
          list.each do |item|
            block.call(item)
          end
          
          break if next_page == nil
          
          request.page = next_page
        end
      end
    end
  end
end
