module JusticeGovSk
  class Storage
    class HearingPage < JusticeGovSk::Storage::Page
      include Core::Storage::Distributed

      def root
        @root ||= File.join super, 'hearings'
      end
    end
  end
end
