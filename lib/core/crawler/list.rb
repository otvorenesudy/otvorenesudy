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

      def crawl(request, offset = nil, limit = nil)
        @offset, @limit = offset, limit
        @total = @count = 0
        
        counter      = @limit  if @limit
        request.page = @offset if @offset
        
        loop do
          if @limit
            counter -= 1
            
            break if counter < 0
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
        "request #{@request.class.name} on page #{@request.page} of #{@pages || '?'}, max. #{@limit ? pluralize(@limit, 'page') : '? pages'}, max. #{@request.per_page ? pluralize(@request.per_page, 'item') : '?'} per page"
      end
      
      def state_page
        "page #{@page || 'N/A'} of #{@pages || 'N/A'}, #{@result ? pluralize(@result.count, 'item') : '?'}, next page #{@next_page || 'N/A'}"
      end
      
      def state_item
        "item #{@count} of total #{@total}, item #{@index} of #{@result.count} on page #{@page || 'N/A'} of #{@pages || 'N/A'}"
      end
    end
  end
end
