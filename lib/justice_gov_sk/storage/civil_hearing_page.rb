module JusticeGovSk
  module Storage
    class CivilHearingPage < JusticeGovSk::Storage::HearingPage
      def root
        @root ||= File.join super, 'civil'
      end
    end
  end
end
