module JusticeGovSk
  class Storage
    class SelectionProcedurePage < JusticeGovSk::Storage::Page
      def root
        @root ||= File.join super, 'selection_procedures'
      end
    end
  end
end
