require 'docsplit'

class TextExtractor
  attr_accessor :cache_root,
                :use_ocr

  def initialize
    @document_formats = [:pdf]
    @cache_path       = File.join(Rails.root, 'tmp', 'documents', 'extracted')
    @use_ocr          = false
  end

  def preextract(path)
    raise "File not exists (#{path})" if not File.exists?(path)

    extension = path.split('.').last.to_sym

    raise 'Unsupported document type' if not @document_formats.include?(extension)

    FileUtils.mkpath(@cache_root) if not File.exists?(@cache_root)
    
    return path, extension
  end

  def extract(path)
    path, extension = preextract(path)

    # TODO: resolve files with multiple extensions, unite document format list with doc. request  
    case extension
    when :pdf 
      Docsplit.extract_text(path, :ocr => @use_ocr, :output => @cache_root)

      path = File.basename(path).sub(/\..+\Z/, '.txt')
      
      file = File.join(@cache_root, path)
      
      return File.open(file).read
    end
  end
end

