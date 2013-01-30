module Core
  module Extractor
    module Text
      include Core::Extractor
      
      def extract(path, options = {})
        options = extract_defaults.merge options
        
        super(path) do |extension|
          options[:output] = root
          
          Docsplit.extract_text(path, options)
          
          unload "#{File.basename(path, ".#{extension.to_s}")}.txt"
        end
      end
      
      protected
      
      def postextract(content)
        super content, "#{content.size} characters"
      end
      
      private

      def extract_defaults
        { ocr: false }
      end
      
      include Core::Storage::Cache
      
      def root
        @root ||= File.join super, 'extracts'
      end
    end
  end
end
