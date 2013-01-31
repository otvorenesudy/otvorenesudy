module Core
  module Extractor
    module Text
      include Core::Extractor
      include Core::Extractor::Cache
      
      def extract(path, options = {})
        options = extract_defaults.merge options
        
        super do |extension|
          options[:output] = root
          
          Docsplit.extract_text path, options
          
          unload "#{File.basename path, ".#{extension.to_s}"}.txt"
        end
      end
      
      private

      def extract_defaults
        { subject: :text, unit: :character, ocr: false }
      end
    end
  end
end
