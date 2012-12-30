module JusticeGovSk
  class Crawler
    class List < JusticeGovSk::Crawler
      attr_reader :per_page,
                  :page,
                  :pages,
                  :next_page
      
      def initialize(downloader, parser = nil, persistor = nil)
        parser ||= JusticeGovSk::Parser::List.new

        super(downloader, parser, persistor)

        @per_page  = nil
        @page      = nil
        @pages     = nil
        @next_page = nil
      end
          
      def crawl(request)
        introduce
        puts "Request #{request.class.name} on page #{request.page} of #{@pages || '?'}, max. #{pluralize request.per_page, 'item'} per page."
        
        list = []
        
        content  = @downloader.download(request)
        document = @parser.parse(content)
        
        @per_page  = @parser.per_page(document)
        @page      = @parser.page(document)
        @pages     = @parser.pages(document)
        @next_page = @parser.next_page(document)
        
        list = @parser.list(document)
        
        list = yield list if block_given?
        
        puts "done (page #{@page || 'N/A'} of #{@pages || 'N/A'}, #{pluralize list.nil? ? '?' : list.count, 'item'}, next page #{@next_page || 'N/A'})"
        
        list
      end
      
      def crawl_and_process(request, offset = 1, limit = nil)
        request.page = offset
        
        loop do
          unless limit.nil?
            limit -= 1
            
            break if limit < 0
          end
          
          list = crawl request
          
          list.each { |item| yield item if block_given? }
          
          break if next_page == nil
          
          request.page = next_page
        end
      end
    end
  end
end
