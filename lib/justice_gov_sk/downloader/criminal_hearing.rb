module JusticeGovSk
  class Downloader
    class CriminalHearing < JusticeGovSk::Downloader
      def storage
        @storage ||= JusticeGovSk::Storage::CriminalHearingPage
      end
    end
  end
end
