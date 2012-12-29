module JusticeGovSk
  module Storages
    class CriminalHearingPageStorage < JusticeGovSk::Storages::HearingPageStorage
      def root
        @root ||= File.join super, 'criminal'
      end
    end
  end
end
