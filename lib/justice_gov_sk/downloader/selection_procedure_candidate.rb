module JusticeGovSk
  class Downloader
    class SelectionProcedureCandidate < JusticeGovSk::Downloader
      def storage
        @storage ||= JusticeGovSk::Storage::SelectionProcedureCandidatePage.instance
      end
    end
  end
end
