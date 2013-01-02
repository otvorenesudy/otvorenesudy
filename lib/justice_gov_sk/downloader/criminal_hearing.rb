module JusticeGovSk
  class Downloader
    class CriminalHearing < JusticeGovSk::Downloader
      def storage
        @storage ||= JusticeGovSk::Storage::CriminalHearingPage.instance
      end
    end
  end
end
