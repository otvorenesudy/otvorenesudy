module JusticeGovSk
  class Storage
    class HearingPage < JusticeGovSk::Storage::Page
      def initialize
        @distribute = true
      end

      def root
        @root ||= File.join super, 'hearings'
      end
    end
  end
end
