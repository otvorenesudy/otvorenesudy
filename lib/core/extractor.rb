module Core
  module Extractor
    include Core::Output
    
    attr_accessor :formats
    
    def extract(path)
      return unless format = preextract(path)
      postextract yield format
    end
    
    protected
    
    def preextract(path)
      print "Extracting #{path} ... "
      
      format = path.split('.').last.to_sym      
      
      puts "failed (not readable)"          unless File.readable?(path)
      puts "failed (unsupported file type)" unless formats.include?(format)
      
      format
    end
    
    def postextract(result, note = nil)
      puts "#{result ? "done" : "failed"}#{!note.blank? ? " (#{note})" : ''}"
      result
    end
  end
end
