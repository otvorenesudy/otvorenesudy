module Core
  module Storage
    module Distributed
      def each
        super do |bucket|
          Dir.foreach(File.join root, bucket) do |entry|
            yield entry, bucket unless entry.start_with? '.'
          end
        end
      end
      
      def batch
        Dir.foreach(root) do |bucket|
          yield Dir.entries(File.join root, bucket).select { |e| !e.start_with? '.' }, bucket
        end
      end
      
      def bucket(entry)
        partition(entry)[-2]
      end
      
      protected
      
      def partition(entry)
        parts = super(entry)
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
