module JusticeGovSk
  class Storage
    class DecreeDocument < JusticeGovSk::Storage::Document
      include Core::Storage::Distributed

      def root
        @root ||= File.join super, 'decrees'
      end
    end
  end
end
