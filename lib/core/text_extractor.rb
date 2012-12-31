module Core
  class TextExtractor
    def initialize
      @formats = [:pdf]
      @use_ocr = false

      @binary      = false
      @distributed = false
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
      raise "File not readable #{path}" unless File.readable?(path)
  
      extension = path.split('.').last.to_sym
      file      = "#{File.basename(path, ".#{extension.to_s}")}.txt"
  
      raise "Unsupported file type #{extension}" unless @formats.include?(extension)
      
      return file, extension
    end
    
    private
    
    include Core::Storage::Cache
  
    def root
      @root ||= File.join super, 'extracts'
    end
  end
end
