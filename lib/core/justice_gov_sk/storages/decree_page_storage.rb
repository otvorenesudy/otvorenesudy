module JusticeGovSk
  module Storages
    class DecreePageStorage < JusticeGovSk::Storages::PageStorage
      def initialize
        @distribute = true
      end

      def root
        @root ||= File.join super, 'decrees'
      end
    end
  end
end
