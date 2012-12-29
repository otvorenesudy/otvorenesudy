module JusticeGovSk
  module Storages
    class DocumentStorage
      include Storage
      
      def initialize
        @binary     = true
        @distribute = true
      end

      def root
        @root ||= File.join super, 'documents'
      end
    end
  end
end
