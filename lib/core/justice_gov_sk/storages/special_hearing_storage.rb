module JusticeGovSk
  module Storages
    class SpecialHearingStorage < JusticeGovSk::Storages::HearingStorage
      def root
        @root ||= File.join super, 'special'
      end
    end
  end
end
