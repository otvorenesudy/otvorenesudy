module Core
  module Storage
    module Distributed
      def each
        super do |bucket|
          Dir.foreach(File.join root, bucket) do |path|
            yield path, bucket unless path.start_with? '.'
          end
        end
      end
      
      def bucket(path)
        partition(path)[-2]
      end
      
      protected
      
      def partition(path)
        parts = super(path)
        parts << parts.last
        parts[-2] = distribute(parts.last)
        parts
      end
      
      private
      
      def distribute(file)
        '%02x' % hash(file)
      end
      
      def hash(string)
        MurmurHash3::V32.str_hash(string) % 256
      end
    end
  end
end
