module JusticeGovSk
  module Storages
    class HearingStorage < JusticeGovSk::Storages::PageStorage
      def initialize
        @distribute = true
      end

      def root
        @root ||= File.join super, 'hearings'
      end
    end
  end
end
