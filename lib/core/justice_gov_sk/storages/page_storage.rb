module JusticeGovSk
  module Storages
    class PageStorage
      include Storage
      
      def initialize
        @binary = false
      end
      
      def root
        @root ||= File.join 'storage', 'pages'
      end
    end
  end
end
