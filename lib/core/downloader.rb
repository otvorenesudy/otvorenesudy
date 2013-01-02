module Core
  module Downloader
    include Core::Output
    
    attr_accessor :storage,
                  :uri_to_path,
                  :headers,
                  :data,
                  :repeat,
                  :timeout,
                  :wait_time
    
    def initialize
      @headers   = { 'User-Agent' => 'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:11.0) Gecko/20100101 Firefox/11.0' }
      @data      = {}
      
      @repeat    = 8
      @timeout   = 2.minutes
      
      @wait_time = 0.5.seconds
    end
  
    def download(request)
      uri, path, content = predownload(request)
      
      return content unless content.nil?
      
      e = nil
  
      1.upto repeat do |i|
        wait
  
        begin
          handler = Curl::Easy.new
          
          handler.url             = URI.encode(uri)
          handler.connect_timeout = timeout
          handler.timeout         = timeout
        
          print "Downloading #{uri} ... "
        
          headers.each { |p, v| handler.headers[p] = v }
          data.empty? ? handler.http_get : handler.http_post(data)
  
          handler.perform
          
          content = handler.body_str
  
          if handler.response_code == 200
            puts "done (#{content.length} bytes)"
            
            store(path, content)
            
            return content
          end
          
          e = "Invalid response code #{handler.response_code}"
          
          puts "failed (response code #{handler.response_code}, attempt #{i} of #{repeat})"
        rescue Curl::Err::HostResolutionError => e
          puts "failed (host resolution error, attempt #{i} of #{repeat})"
        rescue Curl::Err::TimeoutError, Timeout::Error => e
          puts "failed (connection timed out, attempt #{i} of #{repeat})"
        rescue Exception => e
          puts "failed (unable to handle #{e.class.name})"
          break
        ensure
          handler.close unless handler.nil?
        end
      end
  
      raise e || 'Unable to download'
    end
    
    protected
    
    def predownload(request)
      uri     = Core::Request.uri request
      path    = uri_to_path uri
      content = load(path)
      
      return uri, path, content
    end

    def uri_to_path(uri)
      @uri_to_path.call(uri) if @uri_to_path
    end
    
    def wait
      unless wait_time.nil? || wait_time <= 0
        print "Waiting #{wait_time} sec. ... "
  
        sleep wait_time
  
        puts "done"
      end
    end
    
    protected
    
    def load(path)
      if storage
        print "Loading #{fullpath path} ... "
        
        if storage.contains? path
          if storage.loadable? path
            # TODO fix
            if @cache.valid? path
              content = storage.load path
              
              puts "done (#{content.length} bytes)"
            else
              puts "failed (expired)"
            end
          else
            puts "failed (not readable)"
          end
        else
          puts "failed (not exists)"
        end
      end
    end
    
    def store(path, content)
      if storage
        print "Storing #{fullpath path} ... "
        
        storage.store path, content
        
        puts "done (#{content.length} bytes)"
      end
    end
  end  
end
