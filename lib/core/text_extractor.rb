require 'docsplit'

class TextExtractor
  attr_accessor :cache_path,
    :use_ocr

  def initialize
    @use_ocr = false
    @cache_path = File.join(Rails.root, 'tmp', 'documents', 'extracted')
    @supported_filetypes = [:pdf]
  end

  def preextract(path)
    raise "File does not exists (#{path})" if not File.exists?(path)

    file_ext = path.split('.').last.to_sym

    raise 'Unsupported file extension' if not @supported_filetypes.include?(file_ext)

    @document_path = path
    @document_type = file_ext

    FileUtils.mkdir_p(@cache_path) if not File.exists?(@cache_path)
  end

  def extract(document_path)
    preextract(document_path)
  
    case @document_type
    when :pdf 
      Docsplit.extract_text(@document_path, :ocr => @use_ocr, :output => @cache_path)

      # TODO: resolve files with multiple extensions
      ext_file = File.basename(@document_path).sub(/\..+\Z/, ".txt")
      file = File.join(@cache_path, ext_file)
      @content = File.open(file).read
    end
  
    @content
  end
end

