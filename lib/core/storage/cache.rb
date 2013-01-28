module Core
  module Storage
    module Cache
      include Core::Storage
      
      attr_accessor :expire_time
      
      def root
        @root ||= Core::Configuration.cache
      end
      
      def expired?(path)
        (Time.now - File.ctime(fullpath(path))) >= @expire_time unless @expire_time.nil?
      end
      
      def load(path)
        super(path) unless expired?(path)
      end
    end
  end
end
