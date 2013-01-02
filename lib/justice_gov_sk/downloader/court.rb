module JusticeGovSk
  class Downloader
    class Court < JusticeGovSk::Downloader
      def storage
        @storage ||= JusticeGovSk::Storage::CourtPage.instance
      end
    end
  end
end
