module JusticeGovSk
  module Storages
    class CriminalHearingStorage < JusticeGovSk::Storages::HearingStorage
      def root
        @root ||= File.join super, 'criminal'
      end
    end
  end
end
