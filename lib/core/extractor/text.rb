module Core
  module Extractor
    module Text
      attr_accessor :use_ocr
      
      def extract(path)
        super do |format|
          file = "#{File.basename(path, ".#{format.to_s}")}.txt"
          
          case format
          when :pdf
            Docsplit.extract_text(path, ocr: use_ocr, output: root)
            
            content = load(file)
            
            remove(file)
          end
          
          return content, "#{content.size} characters"
        end
      end
      
      def formats
        @formats ||= [:pdf]
      end
      
      def use_ocr
        @use_ocr.nil? ? false : @use_ocr
      end
      
      private
      
      include Core::Storage::Cache
      
      def root
        @root ||= File.join super, 'extracts'
      end
    end
  end
end
