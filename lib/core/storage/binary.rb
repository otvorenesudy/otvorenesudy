module Core
  module Storage
    module Binary
      protected
      
      def read(path)
        File.open(path, 'rb') { |file| yield file }
      end
      
      def write(path)
        File.open(path, 'wb') { |file| yield file }
      end
    end
  end
end
