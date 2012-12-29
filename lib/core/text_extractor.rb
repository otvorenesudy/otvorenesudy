require 'docsplit'

module Core
  class TextExtractor
    def initialize
      @binary      = false
      @distributed = false
      
      @document_formats = [:pdf]
      @use_ocr          = false
    end
  
    def extract(path)
      file, extension = preextract(path)
  
      case extension
      when :pdf
        Docsplit.extract_text(path, ocr: @use_ocr, output: root)
        
        content = load(file)
        
        remove(file)
      end
      
      content
    end
  
    protected
    
    def preextract(path)
      raise "File not exists #{path}" unless File.exists?(path)
  
      extension = path.split('.').last.to_sym
      file      = "#{File.basename(path, ".#{extension.to_s}")}.txt"
  
      raise "Unsupported file type #{extension}" unless @document_formats.include?(extension)
      
      return file, extension
    end
    
    private
    
    include Core::Cache
  
    def root
      @root ||= File.join super, 'text'
    end
  end
end
