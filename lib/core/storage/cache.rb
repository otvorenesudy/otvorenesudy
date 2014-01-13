module Core
  module Storage
    module Cache
      include Core::Storage

      attr_accessor :expire_time

      def root
        @root ||= Core::Configuration.storage.cache.root
      end

      def expired?(entry)
        (Time.now - File.ctime(path(entry))) >= @expire_time unless @expire_time.nil?
      end

      def load(entry)
        super(entry) unless expired?(entry)
      end
    end
  end
end
