module JusticeGovSk
  module Storages
    class CivilHearingStorage < JusticeGovSk::Storages::HearingStorage
      def root
        @root ||= File.join super, 'civil'
      end
    end
  end
end
