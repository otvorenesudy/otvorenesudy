module JusticeGovSk
  class Downloader
    class SelectionProcedure < JusticeGovSk::Downloader
      def storage
        @storage ||= JusticeGovSk::Storage::SelectionProcedurePage.instance
      end
    end
  end
end
