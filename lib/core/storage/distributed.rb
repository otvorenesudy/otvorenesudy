module Core
  module Storage
    module Distributed
      def each
        super do |bucket|
          Dir.foreach(bucket) do |path|
            yield path, bucket unless file.start_with? '.'
          end
        end
      end
      
      protected
      
      def partition(path)
        parts = super(path)
        parts << parts[parts.size - 1]
        parts[parts.size - 2] = bucket(parts.last)
        parts
      end
      
      private
      
      def bucket(file)
        '%02x' % hash(file)
      end
      
      def hash(string)
        MurmurHash3::V32.str_hash(string) % 256
      end
    end
  end
end
