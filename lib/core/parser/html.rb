# TODO find more common super type for HTML and JSON parser, consider Support module? 

module Core
  module Parser
    module HTML
      include Core::Output
      include Core::Parser
      
      def parse(content)
        print "Parsing content ... "
        
        if content.is_a?(Nokogiri::XML::Node) || content.is_a?(Mechanize::Page)
          puts "done (already parsed)"
          
          document = content
        else
          content  = content.encode Encoding::UTF_8, encoding(content)
          document = Nokogiri::HTML::parse(content)
          
          puts "done"
        end
        
        document
      end
      
      private
      
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
