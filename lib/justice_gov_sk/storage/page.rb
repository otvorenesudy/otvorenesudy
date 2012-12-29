module JusticeGovSk
  module Storage
    class Page < JusticeGovSk::Storage
      def initialize
        @binary = false
      end
      
      def root
        @root ||= File.join super, 'pages'
      end
    end
  end
end
