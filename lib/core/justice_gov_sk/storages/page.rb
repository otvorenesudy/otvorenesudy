module JusticeGovSk
  module Storages
    module Document
      extend Storage
      
      def self.root
        @root ||= File.join super, 'pages'
      end
      
      @binary = false
    end
  end
end
