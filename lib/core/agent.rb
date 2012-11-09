require 'mechanize'

# TODO find a common super class / module for downloader & agent

class Agent
  include Output

  attr_accessor :cache_expire_time,
                :cache_file_extension,
                :cache_load,
                :cache_store,
                :cache_uri_to_path,
                :timeout,
                :repeat,
                :wait_time

  def initialize
    @agent = Mechanize.new
    
    @cache_expire_time    = nil
    @cache_file_extension = nil
    @cache_load           = false
    @cache_store          = true
    @repeat               = 4
    @timeout              = 30.seconds
    @wait_time            = 2.seconds
    @cache_uri_to_path    = lambda { |downloader, uri| uri_to_path(uri) }
  end

  def download(request)
    path = @cache_uri_to_path.call(self, request.url) 

    FileUtils.mkpath(File.dirname(path)) if @cache_store

    if @cache_load
      content = load(path)

      return content unless content.nil?
    end

    e = nil

    1.upto @repeat do |i|
      wait

      begin 
        print "Getting page #{request.url}"

        @page = @agent.get(request.url)

        puts " done (#{@page.content.length} bytes)"

        if block_given?
          @page = yield @page
        end

        if @page
          content = @page.content
          
          store(path, content) if @cache_store
          
          return content
        else
          raise "Empty page"
        end

      rescue Mechanize::Error => e
        puts "Unable to download page. Attempt ##{i} from #{@repeat}"
      rescue Exception => e 
        puts "Unable to handle error: #{e.class.name}." 
        break
      end
    end
    
    raise e or "Unable to download"  
  end

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
    uri_to_path downloader.cache_file_extension.nil? ? uri : "#{uri}.#{downloader.cache_file_extension}"
  end
end
