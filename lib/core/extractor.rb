module Core
  module Extractor
    include Core::Output
    
    def extract(path, options = {})
      return unless extension = preextract(path, options)
      postextract(yield(extension), options)
    end
    
    protected
    
    def preextract(path, options = {})
      subject = options[:subject]
      
      print "Extracting#{subject.blank? ? '' : " #{subject}"} from #{path} ... "
      puts  "failed (not readable)" unless File.readable?(path)
      
      path.split('.').last.to_sym
    end
    
    def postextract(result, options = {})
      message = options[:message]

      unless message && result.respond_to?(:size)      
        unit    = options[:unit].to_s
        size    = result.size
        message = "#{size}#{unit.blank? ? '' : " #{unit.pluralize size}"}"
      end
      
      puts "#{result ? 'done' : 'failed'}#{message.blank? ? '' : " (#{message})"}"
      
      result
    end
  end
end
