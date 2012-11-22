module JusticeGovSk
  module Storages
    class CivilHearingPageStorage < JusticeGovSk::Storages::HearingPageStorage
      def root
        @root ||= File.join super, 'civil'
      end
    end
  end
end
