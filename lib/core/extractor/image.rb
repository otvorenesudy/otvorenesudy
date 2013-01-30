module Core
  module Extractor
    module Image
      include Core::Extractor
      
      def extract(path, options = {})
        options = extract_defaults.merge options
        
        super do
          options[:output] ||= File.dirname path
          
          Docsplit.extract_images(path, options)
        end
      end
      
      def formats
        @formats ||= [:pdf]
      end
      
      private
      
      def extract_defaults
        { rolling: true, size: ['1000x'], format: :png }
      end
    end
  end
end
