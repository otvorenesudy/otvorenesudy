module JusticeGovSk
  module Storages
    class DecreeDocumentStorage < JusticeGovSk::Storages::DocumentStorage
      def root
        @root ||= File.join super, 'decrees'
      end
    end
  end
end
