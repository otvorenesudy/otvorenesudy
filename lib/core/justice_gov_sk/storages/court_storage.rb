module JusticeGovSk
  module Storages
    class CourtStorage < JusticeGovSk::Storages::PageStorage
      def initialize
        @distribute = false
      end

      def root
        @root ||= File.join super, 'courts'
      end
    end
  end
end
