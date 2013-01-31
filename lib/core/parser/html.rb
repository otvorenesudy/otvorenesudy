module Core
  module Parser
    module HTML
      include Core::Output
      include Core::Parser
      
      def parse(content, options = {})
        super do
          if content.is_a?(Nokogiri::XML::Node) || content.is_a?(Mechanize::Page)
            options[:message] = "already parsed"
            
            content
          else
            content = content.encode Encoding::UTF_8, encoding(content)
            
            Nokogiri::HTML::parse(content)
          end
        end
      end
      
      private
      
      def encoding(content, options = {})
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
