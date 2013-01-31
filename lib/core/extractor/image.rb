module Core
  module Extractor
    module Image
      include Core::Extractor
      include Core::Extractor::Cache
      
      def extract(path, options = {})
        options = extract_defaults.merge options
        
        super do
          dir = File.join root, File.basename(path)
          
          Docsplit.extract_images path, options.merge(output: dir)
          
          images = Dir.entries(dir).select { |f| !f.start_with? '.' }
          
          images.each do |f|
            s = File.join dir, f
            d = File.join options[:output], f.scan(/\_(\d+\.\w+)\z/).first
            
            FileUtils.mv s, d
          end
          
          FileUtils.remove_entry dir
          
          images
        end
      end
      
      def formats
        @formats ||= [:pdf]
      end
      
      private
      
      def extract_defaults
        { subject: :images, unit: :page, rolling: true, size: '940x', format: :png }
      end
    end
  end
end
