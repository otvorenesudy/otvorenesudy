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
    
        @page      = 1
        @pages     = nil
        @per_page  = nil
        @next_page = nil
      end
    
      def crawl(request)
        introduce
        puts "Working on page #{request.page} of #{@pages || '?'}, max. #{pluralize request.per_page, 'item'} per page."
        
        list = []
        
        @downloader.headers = request.headers
        @downloader.data    = request.data
        
        content  = @downloader.download(request.url)
        document = @parser.parse(content)
        
        @page      = @parser.page(document)
        @pages     = @parser.pages(document)
        @per_page  = @parser.per_page(document)
        @next_page = @parser.next_page(document)
        
        # TODO rm
        puts "YYYY page     = #{@page}"
        puts "YYYY per_page = #{@per_page}"
        
        list = @parser.list(document)
    
        puts "done (page #{@page} of #{@pages}, #{pluralize list.count, 'item'}, next page #{@next_page || 'N/A'})"
        
        list
      end
    end
  end
end
