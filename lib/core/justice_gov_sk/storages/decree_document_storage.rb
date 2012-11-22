module JusticeGovSk
  module Storages
    class DecreeDocumentStorage
      def root
        @root ||= File.join super, 'decrees'
      end
    end
  end
end
