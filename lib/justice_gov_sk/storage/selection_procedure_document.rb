module JusticeGovSk
  class Storage
    class SelectionProcedureDocument < JusticeGovSk::Storage::Document
      def root
        @root ||= File.join super, 'selection_procedures'
      end
    end
  end
end
