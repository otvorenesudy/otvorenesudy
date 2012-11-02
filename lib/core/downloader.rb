require 'net/http'

# TODO refactor don't use net/http !!

class Downloader
  attr_accessor :cache_expire_time,
                :cache_file_extension,
                :cache_load,
                :cache_store,
                :headers,
                :params,
                :repeat,
                :timeout,
                :wait_time
    
  def initialize
    @cache_expire_time    = 1.year # TODO change
    @cache_file_extension = nil
    @cache_load           = true
    @cache_store          = true
    
    @headers              = { 'User-Agent' => 'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:11.0) Gecko/20100101 Firefox/11.0' }
    @params               = {}

    @repeat               = 8
    @timeout              = 30.seconds
    
    @wait_time            = 2.seconds
  end
  
  def download(uri)
    path = uri_to_path(uri)
    
    FileUtils.mkpath(File.dirname(path)) if @cache_store

    content = load(path) if @cache_load
    
    return content unless content.nil?
    
    exception = nil;
    
    uri = URI.parse(uri)

    1.upto @repeat do |i|
      wait
      
      begin
        print "Downloading #{uri} ... "
            
        Net::HTTP.start(uri.host, uri.port) do |http|
          request = Net::HTTP::Post.new(uri.request_uri)

          @headers.each { |k, v| request[k] = v }
        
          request.form_data = @params
          
          http.read_timeout = @timeout

          response = http.request(request)

          case response
            when Net::HTTPSuccess then
              content = response.body
              
              puts "done (#{content.length} bytes)"

              store(path, content) if @cache_store

              return content
            else
              puts "failed (#{response.code} #{response.message})"
              raise "#{response.code} #{response.message}"
          end
        end
      rescue Errno::ECONNRESET, Errno::ECONNREFUSED => e
        puts "failed (#{e.message.downcase}, attempt #{i} of #{@repeat})"
        exception = e
      rescue Errno::ETIMEDOUT, Timeout::Error => e
        puts "failed (connection timed out, attempt #{i} of #{@repeat})"
        exception = e
      rescue Exception => e
        puts "failed (unable to handle #{e.class.name})"
        exception = e
        break
      end
    end
    
    raise exception || "Unknown error"
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
 
  def uri_to_path(uri)
    super @cache_file_extension.nil? ? uri : "#{uri}.#{@cache_file_extension}"
  end
end
