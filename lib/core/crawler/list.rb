module Core
  module Crawler
    module List
      include Core::Crawler
      include Core::Output
      include Core::Pluralize
      
      attr_reader :per_page,
                  :page,
                  :pages,
                  :next_page

      def crawl(request, offset = 1, limit = nil)
        request.page = offset
        
        loop do
          unless limit.nil?
            limit -= 1
            
            break if limit < 0
          end
          
          super(request)
          
          break if next_page == nil
          
          request.page = next_page
        end
      end
         
      protected
      
      def process(request)
        @request = request
        
        puts "Request #{@request.class.name} on page #{@request.page} of #{@pages || '?'}, max. #{pluralize @request.per_page, 'item'} per page."
        
        @content  = @downloader.download(request)
        @document = @parser.parse(@content)
        
        @per_page  = @parser.per_page(@document)
        @page      = @parser.page(@document)
        @pages     = @parser.pages(@document)
        @next_page = @parser.next_page(@document)
         
        @result = @parser.list(@document)
        
        puts "Processing list #{state}."
        
        @result.each { |item| yield item }
      end
      
      def postcrawl
        super "finished (#{state})"
      end
      
      private
      
      def state
        "page #{@page || 'N/A'} of #{@pages || 'N/A'}, #{pluralize @result.nil? ? '?' : @result.count, 'item'}, next page #{@next_page || 'N/A'}"
      end      
    end
  end
end
