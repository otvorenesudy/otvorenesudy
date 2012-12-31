# TODO refactor: downloader should have a storage, it should not be the storage
module Core
  module Downloader
    include Core::Output
    
    attr_accessor :cache_load,
                  :cache_store,
                  :cache_uri_to_path,
                  :headers,
                  :data,
                  :repeat,
                  :timeout,
                  :wait_time
  
    def initialize
      @cache_load        = false
      @cache_store       = false
      @cache_uri_to_path = lambda { |uri| self.uri_to_path uri }
  
      @headers           = { 'User-Agent' => 'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:11.0) Gecko/20100101 Firefox/11.0' }
      @data              = {}
  
      @repeat            = 8
      @timeout           = 2.minutes
  
      @wait_time         = 0.5.seconds
    end
  
    def download(request)
      uri, path, content = predownload(uri)
      
      return content unless content.nil?
      
      e = nil
  
      1.upto @repeat do |i|
        wait
  
        begin
          handler = Curl::Easy.new
          
          handler.url             = URI.encode(uri)
          handler.connect_timeout = @timeout
          handler.timeout         = @timeout
        
          print "Downloading #{uri} ... "
        
          @headers.each { |p, v| handler.headers[p] = v }
          @data.empty? ? handler.http_get : handler.http_post(@data)
  
          handler.perform
          
          content = handler.body_str
  
          if handler.response_code == 200
            puts "done (#{content.length} bytes)"
            
            store(path, content)
            
            return content
          end
          
          e = "Invalid response code #{handler.response_code}"
          
          puts "failed (response code #{handler.response_code}, attempt #{i} of #{@repeat})"
        rescue Curl::Err::HostResolutionError => e
          puts "failed (host resolution error, attempt #{i} of #{@repeat})"
        rescue Curl::Err::TimeoutError, Timeout::Error => e
          puts "failed (connection timed out, attempt #{i} of #{@repeat})"
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
      if request.respond_to? :uri
        uri = request.uri
      elsif request.respond_to? :url
        uri = request.url
      else
        uri = request.to_s
      end
      
      path    = @cache_uri_to_path.call uri
      content = load(path)
      
      return uri, path, content
    end
    
    def uri_to_path(uri)
      uri = URI.parse(uri)
      uri.query.nil? ? uri.path : "#{uri.path}?#{uri.query}"
    end
  
    def wait
      unless @wait_time.nil? || @wait_time <= 0
        print "Waiting #{@wait_time} sec. ... "
  
        sleep @wait_time
  
        puts "done"
      end
    end
  
    include Core::Storage::Cache
    
    public
  
    alias :cache_root= :root=
    alias :cache_root  :root
  
    alias :cache_binary= :binary=
    alias :cache_binary  :binary
  
    alias :cache_distribute= :distribute=
    alias :cache_distribute  :distribute
  
    alias :cache_expire_time= :expire_time=
    alias :cache_expire_time  :expire_time
  
    def cache_load_and_store=(value)
      @cache_load = @cache_store = value
    end
    
    protected
    
    def load(path)
      if @cache_load
        print "Loading #{fullpath path} ... "
    
        if contains? path
          if loadable? path
            if expired? path
              puts "failed (expired)"
              return nil
            end
      
            content = super path
      
            puts "done (#{content.length} bytes)"
      
            content
          else
            puts "failed (not readable)"
          end
        else
          puts "failed (not exists)"
        end
      end
    end
  
    def store(path, content)
      if @cache_store
        print "Storing #{fullpath path} ... "
    
        super path, content
    
        puts "done (#{content.length} bytes)"
      end
    end
  end  
end
