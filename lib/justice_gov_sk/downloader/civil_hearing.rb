module JusticeGovSk
  class Downloader
    class CivilHearing < JusticeGovSk::Downloader
      def storage
        @storage ||= JusticeGovSk::Storage::CivilHearingPage.instance
      end
    end
  end
end
