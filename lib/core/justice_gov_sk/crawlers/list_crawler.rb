module JusticeGovSk
  module Crawlers
    class ListCrawler < Crawler
      include Pluralize
      
      attr_accessor :request,
                    :page
      
      attr_reader :pages,
                  :per_page,
                  :next_page
      
      def initialize(downloader)
        super(downloader, JusticeGovSk::Parsers::ListParser.new, nil)
    
        @page      = 1
        @pages     = nil
        @per_page  = 100
        @next_page = nil
      end
    
      def crawl(request)
        introduce
        puts "Working on page #{@page} of #{@pages || '?'}, max. #{pluralize @per_page, 'item'} per page."
    
        list = []
        
        request.page     = @page
        request.per_page = @per_page
        
        @downloader.headers = request.headers
        @downloader.data    = request.data
        
        content  = @downloader.download(request.url)
        document = @parser.parse(content)
        
        @page      = @parser.page(document)
        @pages     = @parser.pages(document)
        @per_page  = @parser.per_page(document)
        @next_page = @parser.next_page(document)
        
        list = @parser.list(document)
    
        puts "done (page #{@page} of #{@pages}, #{pluralize list.count, 'item'} (max. #{pluralize @per_page, 'item'}), next page #{@next_page || 'N/A'})"
        
        list
      end
    end
  end
end
