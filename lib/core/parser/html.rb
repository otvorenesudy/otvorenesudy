module Core
  module Parser
    module HTML
      include Core::Parser
      
      def parse(content)
        clear_caches if self.respond_to? :clear_caches
        
        print "Parsing resource ... "
        
        if resource.is_a?(Nokogiri::XML::Node) || resource.is_a?(Mechanize::Page)
          puts "done (already parsed)"
          
          document = content
        else
          content  = content.encode Encoding::UTF_8, encoding(content)
          document = Nokogiri::HTML::parse(content)
          
          puts "done"
        end
        
        document
      end
      
      protected
      
      def find_value(name, element, selector = nil, options = {}, &block)
        options = defaults.merge options
       
        print "Parsing #{name} ... "
        
        value = selector.blank? ? element : element.search(selector)
        
        if options[:present?]
          if value.nil?
            puts "failed (not present)"
            return
          end
        end
        
        if options[:empty?]
          if value.respond_to?(:empty?) && value.empty?
            puts "failed (empty)"
            return
          end
            
          if value.respond_to?(:text) && value.text.strip.empty?
            puts "failed (content empty)"
            return
          end
        end
        
        value = block_given? ? block.call(value) : value
    
        puts options[:verbose] ? "done (#{value})" : "done"
    
        value
      end
      
      def find_values(name, element, selector, options = {}, &block)
        find_value(name, element, selector, options, &block) || []
      end
      
      private
      
      def defaults
        {
          present?: true,
          empty?:   true,
          verbose:  true
        }
      end
      
      def encoding(content)
        part = ''
        
        content.bytes do |b|
          part << b
          part.scan(/charset="?[\w\d\-]+"\z/i) { |m| return m.gsub(/"/, '')[8..-1] }
        end
        
        Encoding::UTF_8
      end
    end
  end
end
