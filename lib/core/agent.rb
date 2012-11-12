require 'mechanize'

class Agent < Downloader
  attr_reader :headers,
              :data

  def initialize
    super

    @handler = Mechanize.new
  end

  def download(request)
    uri = request.respond_to?(:url) ? request.url : request
    
    path, content = predownload(uri)
    
    return content unless content.nil?

    @handler.open_timeout = @timeout
    @handler.read_timeout = @timeout

    e = nil

    1.upto @repeat do |i|
      wait

      begin
        print "Getting page #{uri} ... "

        page = @handler.get(uri)

        page = yield page

        if page
          content = page.content
          
          puts "done (#{page.content.length} bytes)"
          
          store(path, content)
          
          return page
        else
          e = "Empty page"
          
          puts "failed (page empty, attempt #{i} of #{@repeat})"
        end

      rescue Mechanize::Error => e
        puts "failed (unable to download page, attempt #{i} of #{@repeat})"
      rescue Timeout::Error => e
        puts "failed (connection timed out, attempt #{i} of #{@repeat})"
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
