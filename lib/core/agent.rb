require 'mechanize'

class Agent < Downloader
  attr_reader :headers,
              :data

  def initialize
    super

    @agent = Mechanize.new
  end

  def download(request)
    path, content = predownload(request.url)
    
    return content unless content.nil?

    e = nil

    1.upto @repeat do |i|
      wait

      begin 
        print "Getting page #{request.url}"

        page = @agent.get(request.url)

        page = yield page if block_given?

        if page
          content = page.content
          
          puts " done (#{page.content.length} bytes)"
          
          store(path, content)
          
          return page
        else
          e = "Empty page"
          
          puts "failed (page empty, attempt #{i} of #{@repeat})"
        end

      rescue Mechanize::Error => e
        puts "failed (unable to download page, attempt #{i} of #{@repeat})"
      rescue Exception => e 
        puts "failed (unable to handle #{e.class.name})" 
        break
      end
    end
    
    raise e || "Unable to download"  
  end
end
