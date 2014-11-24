module JusticeGovSk
  class Downloader
    class SelectionProcedureDocument < JusticeGovSk::Downloader
      def storage
        @storage ||= JusticeGovSk::Storage::SelectionProcedureDocument.instance
      end
    end
  end
end
