module JusticeGovSk
  class Storage
    class SelectionProcedureCandidatePage < JusticeGovSk::Storage::Page
      def root
        @root ||= File.join super, 'selection_procedure_candidates'
      end
    end
  end
end
