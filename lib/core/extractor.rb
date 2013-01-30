module Core
  module Extractor
    include Core::Output
    
    def extract(path)
      return unless extension = preextract(path)
      postextract yield extension
    end
    
    protected
    
    def preextract(path)
      print "Extracting #{path} ... "
      puts  "failed (not readable)" unless File.readable?(path)
      
      path.split('.').last.to_sym
    end
    
    def postextract(result, note = nil)
      puts "#{result ? "done" : "failed"}#{!note.blank? ? " (#{note})" : ''}"
      result
    end
  end
end
