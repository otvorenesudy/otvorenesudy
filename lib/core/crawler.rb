module Core
  module Crawler
    include Core::Output
  
    attr_accessor :downloader,
                  :parser,
                  :persistor
  
    def initialize(downloader, parser, persistor)
      @downloader = downloader
      @parser     = parser
      @persistor  = persistor
    end
    
    def crawl(uri)
      introduce
      
      content = !@downloader.nil? ? @downloader.download(uri) : nil
      
      unless content.nil?
        instance = process(uri, content)
  
        unless instance.nil?
          puts "done"
          
          instance
        else
          puts "failed (no instance)"  
        end      
      else
        puts "failed (no content)"
      end
    end
    
    def verbose=(value)
      @verbose            = value
      @downloader.verbose = value unless @downloader.nil?
      @parser.verbose     = value unless @parser.nil?
      @persistor.verbose  = value unless @persistor.nil? 
    end
  
    protected
    
    def introduce
      print "Running #{self.class.name} using " 
      print "#{@downloader.nil? ? 'no downloader' : @downloader.class.name}, "
      print "#{@parser.nil?     ? 'no parser'     : @parser.class.name} and "
      print "#{@persistor.nil?  ? 'no persistor'  : @persistor.class.name}."
      puts
    end
    
    def process(uri, content)
      instance = !@parser.nil? ? @parser.parse(content) : nil
      
      @persistor.persist(instance) unless @persistor.nil?
      
      instance
    end
  end  
end
