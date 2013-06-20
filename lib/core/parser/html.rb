# encoding: utf-8

module Core
  module Parser
    module HTML
      include Core::Output
      include Core::Parser

      def parse(content, options = {})
        super do
          if content.is_a?(Nokogiri::XML::Node) || content.is_a?(Mechanize::Page)
            options[:message] = "already parsed"

            content = content.body
          else
            content = content.encode Encoding::UTF_8, encoding(content)
          end

          Nokogiri::HTML::parse(normalize_spaces content)
        end
      end

      private

      def normalize_spaces(value)
        value.gsub(/[[:space:]]|(\&nbsp\;?)/, ' ')
      end

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
