module JusticeGovSk
  class Storage
    class DecreeImage < JusticeGovSk::Storage::Image
      include Core::Storage::Distributed

      def root
        @root ||= File.join super, 'decrees'
      end
    end
  end
end
