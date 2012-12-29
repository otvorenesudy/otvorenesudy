module JusticeGovSk
  module Storages
    class PageStorage
      include Storage
      
      def initialize
        @binary = false
      end
      
      def root
        @root ||= File.join super, 'pages'
      end
    end
  end
end
