module JusticeGovSk
  class Downloader
    class SpecialHearing < JusticeGovSk::Downloader
      def storage
        @storage ||= JusticeGovSk::Storage::SpecialHearingPage
      end
    end
  end
end
