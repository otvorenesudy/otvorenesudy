module JusticeGovSk
  class Storage
    class SelectionProcedureCandidateDocument < JusticeGovSk::Storage::Document
      def root
        @root ||= File.join super, 'selection_procedure_candidates'
      end
    end
  end
end
