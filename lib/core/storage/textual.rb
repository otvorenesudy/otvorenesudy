module Core
  module Storage
    module Textual
      attr_accessor :encoding
      
      def encoding
        @encoding ||= Encoding::UTF_8
      end
      
      def store(entry, content)
        super(entry, content.force_encoding(encoding))
      end
      
      protected
      
      def read(path)
        File.open(path, "r:#{encoding}") { |file| yield file }
      end
      
      def write(path)
        File.open(path, "w:#{encoding}") { |file| yield file }
      end
    end
  end
end
