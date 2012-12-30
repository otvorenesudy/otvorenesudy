module JusticeGovSk
  class Storage
    class CourtPage < JusticeGovSk::Storage::Page
      def initialize
        @distribute = false
      end

      def root
        @root ||= File.join super, 'courts'
      end
    end
  end
end
