module JusticeGovSk
  class Storage
    class Document < JusticeGovSk::Storage
      include Core::Storage::Binary

      def root
        @root ||= File.join super, 'documents'
      end
    end
  end
end
