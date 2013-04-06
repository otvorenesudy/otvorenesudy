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
        @offset, @limit = offset, limit
        @total = @count = 0
        
        request.page = offset
        
        loop do
          unless @limit.nil?
            @limit -= 1
            
            break if @limit < 0
          end
          
          super(request)
          
          break if next_page == nil
          
          request.page = next_page
        end
      end
         
      protected
      
      def process(request)
        @request = request
        
        puts "#{state_request.upcase_first}."
        
        @content  = @downloader.download(request)
        @document = @parser.parse(@content)
        
        @per_page  = @parser.per_page(@document)
        @page      = @parser.page(@document)
        @pages     = @parser.pages(@document)
        @next_page = @parser.next_page(@document)
         
        @result = @parser.list(@document)
        
        puts "Processing list #{state_page}."
        
        @total += @result.count
        
        @result.each_with_index do |item, index|
          @count += 1
          @index  = 1 + index
          
          puts "Processing list #{state_item}."
          
          yield item
        end
      end
      
      def postcrawl
        super "finished (#{state_page})"
      end
      
      private
      
      def state_request
        "request #{@request.class.name} on page #{@request.page} of #{@pages || '?'}, max. #{@limit ? pluralize(@limit, 'page') : '? pages'}, max. #{pluralize @request.per_page, 'item'} per page"
      end
      
      def state_page
        "page #{@page || 'N/A'} of #{@pages || 'N/A'}, #{@result.nil? ? '?' : pluralize(@result.count, 'item')}, next page #{@next_page || 'N/A'}"
      end
      
      def state_item
        "item #{@count} of total #{@total}, item #{@index} of #{@result.count} on page #{@page || 'N/A'} of #{@pages || 'N/A'}"
      end
    end
  end
end
