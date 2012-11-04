require 'net/http'

# TODO: Add verbose parameter to turn on/off verbosity

class Downloader
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

  attr_reader   :request,
                :response_code
   

  def initialize
    @cache_expire_time    = 1.year # TODO change
    @cache_file_extension = nil
    @cache_load           = true
    @cache_store          = true
    @cache_uri_to_path    = lambda { |downloader, uri| uri_to_path(downloader, uri) }

    @headers              = { 'User-Agent' => 'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:11.0) Gecko/20100101 Firefox/11.0' }
    @data                 = {}

    @repeat               = 4
    @timeout              = 30.seconds

    @wait_time            = 2.seconds
  end

  def download(uri)
    path = @cache_uri_to_path.call(self, uri)

    FileUtils.mkpath(File.dirname(path)) if @cache_store
     
    if @cache_load
      content = load(path)  

      return content unless content.nil?
    end
    
    e = nil
  
    uri = URI.encode(uri)

    1.upto @repeat do |i|
      wait

      @request = Curl::Easy.http_post(uri, @data) do |curl|
        curl.connect_timeout = @timeout
        
        @headers.each do |param, value|
          curl.headers[param] = value
        end
      end

      begin
        print "Downloading #{uri} ... "

        @request.perform
        
        @response_code = @request.response_code
        
        content = @request.body_str

        if @request.response_code == 200
          puts "done (#{content.length} bytes)"
          
          store(path, content) if @cache_store
          
          return content
        end
        
        puts  "failed (#{content.length} bytes, response code #{@request.response_code})"
        raise "Invalid response code #{@request.response_code}"
        
      rescue Curl::Err::TimeoutError, Timeout::Error => e
        puts "failed (connection timed out, attempt #{i} of #{@repeat})"
      rescue Exception => e
        puts "failed (unable to handle #{e.class.name})"
        break
      end
    end

    raise e || 'Unable to download'
  end

  private

  include Cache

  alias :cache_root= :root=
  alias :cache_root  :root

  def wait
    unless @wait_time.nil? || @wait_time <= 0
      print "Waiting #{@wait_time} sec. ... "

      sleep @wait_time

      puts "done"
    end
  end 

  def load(path)
    print "Loading #{path} ... "

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
  end

  def store(path, content)
    print "Storing #{path} ... "

    super path, content

    puts "done (#{content.length} bytes)"
  end

  def self.uri_to_path(downloader, uri)
    super downloader.cache_file_extension.nil? ? uri : "#{uri}.#{downloader.cache_file_extension}"
  end
end
