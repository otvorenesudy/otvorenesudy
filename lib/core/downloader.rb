require 'net/http'

class Downloader
  include Output
  
  attr_accessor :cache_expire_time,
                :cache_file_extension,
                :cache_load,
                :cache_store,
                :cache_uri_to_path,
                :headers,
                :data,
                :repeat,
                :timeout,
                :wait_time

  def initialize
    @cache_expire_time    = nil
    @cache_file_extension = nil
    @cache_load           = true
    @cache_store          = true
    @cache_uri_to_path    = lambda { |downloader, uri| uri_to_path(uri) }

    @headers              = { 'User-Agent' => 'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:11.0) Gecko/20100101 Firefox/11.0' }
    @data                 = {}

    @repeat               = 4
    @timeout              = 30.seconds

    @wait_time            = 2.seconds
  end

  def download(uri)
    path, content = predownload(uri)
    
    return content unless content.nil?
    
    e = nil
  
    uri = URI.encode(uri)

    1.upto @repeat do |i|
      wait

      # TODO use GET if no data 

      print "Building HTTP/POST request ... "

      request = Curl::Easy.http_post(uri, @data) do |curl|
        curl.connect_timeout = @timeout
        
        @headers.each { |p, v| curl.headers[p] = v }
      end
      
      puts "done (data #{data.size} bytes)"

      begin
        print "Downloading #{uri} ... "

        request.perform
        
        content = request.body_str

        if request.response_code == 200
          puts "done (#{content.length} bytes)"
          
          store(path, content)
          
          return content
        end
        
        e = "Invalid response code #{request.response_code}"
        
        puts "failed (response code #{request.response_code}, attempt #{i} of #{@repeat})"
        
      rescue Curl::Err::TimeoutError, Timeout::Error => e
        puts "failed (connection timed out, attempt #{i} of #{@repeat})"
      rescue Exception => e
        puts "failed (unable to handle #{e.class.name})"
        break
      end
    end

    raise e || 'Unable to download'
  end

  def cache_load_and_store=(value)
    @cache_load = @cache_store = value
  end
  
  protected
  
  include Cache

  alias :cache_root= :root=
  alias :cache_root  :root

  def predownload(uri)
    path = @cache_uri_to_path.call(self, uri)

    FileUtils.mkpath(File.dirname(path)) if @cache_store
     
    content = load(path)

    return path, content
  end

  def wait
    unless @wait_time.nil? || @wait_time <= 0
      print "Waiting #{@wait_time} sec. ... "

      sleep @wait_time

      puts "done"
    end
  end 

  def load(path)
    if @cache_load
      print "Loading #{path} ... "
  
      if File.exists? path
        if File.readable? path
          unless @cache_expire_time.nil?
            delta = Time.now - File.ctime(path)
    
            if delta >= @cache_expire_time
              puts "failed (expired)"  
              return nil
            end 
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
      print "Storing #{path} ... "
  
      super path, content
  
      puts "done (#{content.length} bytes)"
    end
  end

  def self.uri_to_path(downloader, uri)
    uri_to_path downloader.cache_file_extension.nil? ? uri : "#{uri}.#{downloader.cache_file_extension}"
  end
end
