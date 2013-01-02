module Core
  module Storage
    module Binary
      protected
      
      def read(path)
        File.open(path, 'rb') { yield }
      end
      
      def write(path)
        File.open(path, 'wb') { yield }
      end
    end
  end
end
