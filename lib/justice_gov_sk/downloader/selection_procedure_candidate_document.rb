module JusticeGovSk
  class Downloader
    class SelectionProcedureCandidateDocument < JusticeGovSk::Downloader
      def storage
        @storage ||= JusticeGovSk::Storage::SelectionProcedureCandidateDocument.instance
      end
    end
  end
end
