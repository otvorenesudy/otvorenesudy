module JusticeGovSk
  class Storage
    class DecreePage < JusticeGovSk::Storage::Page
      def initialize
        @distribute = true
      end

      def root
        @root ||= File.join super, 'decrees'
      end
    end
  end
end
