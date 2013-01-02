module JusticeGovSk
  class Storage
    class DecreePage < JusticeGovSk::Storage::Page
      include Core::Storage::Distributed

      def root
        @root ||= File.join super, 'decrees'
      end
    end
  end
end
