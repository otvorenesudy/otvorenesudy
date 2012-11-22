module JusticeGovSk
  module Storages
    class SpecialHearingPageStorage < JusticeGovSk::Storages::HearingPageStorage
      def root
        @root ||= File.join super, 'special'
      end
    end
  end
end
