module JusticeGovSk
  class Downloader
    class SpecialHearing < JusticeGovSk::Downloader
      def storage
        @storage ||= JusticeGovSk::Storage::SpecialHearingPage.instance
      end
    end
  end
end
