module Core
  module Agent
    include Core::Downloader
    
    def initialize
      super
  
      @handler = Mechanize.new
    end
  
    def download(request)
      uri, path, content = predownload(request)
      
      return content unless content.nil?
  
      @handler.keep_alive   = false
      @handler.open_timeout = timeout
      @handler.read_timeout = timeout
  
      e = nil
  
      1.upto repeat do |i|
        wait
  
        begin
          print "Getting #{uri} ... "
  
          page = @handler.get(uri)
          @sum = page.content.length
  
          page = yield page if block_given?
  
          if page
            content = page.content
            
            puts "done (#{@sum} bytes)"
            
            store(path, content)
            
            return page
          else
            e = "Empty page"
            
            puts "failed (page empty, attempt #{i} of #{repeat})"
          end
        rescue Mechanize::Error => e
          puts "failed (unable to download page, attempt #{i} of #{repeat})"
        rescue Net::HTTP::Persistent::Error => e
          puts "failed (#{e}, attempt #{i} of #{repeat})"
        rescue Timeout::Error => e
          puts "failed (connection timed out, attempt #{i} of #{repeat})"
        rescue Exception => e 
          puts "failed (unable to handle #{e.class.name})" 
          break
        ensure
          @handler.agent.http.shutdown
        end
      end
      
      raise e || "Unable to download"
    end
    
    def headers=(value)
      raise 'Unsupported'
    end
    
    def data=(value)
      raise 'Unsupported'
    end
    
    def headers
      @handler.request_headers
    end
    
    def data
      raise 'Unsupported'
    end
  end  
end
