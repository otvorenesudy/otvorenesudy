module JusticeGovSk
  class Downloader
    class CivilHearing < JusticeGovSk::Downloader
      def storage
        @storage ||= JusticeGovSk::Storage::CivilHearingPage
      end
    end
  end
end
