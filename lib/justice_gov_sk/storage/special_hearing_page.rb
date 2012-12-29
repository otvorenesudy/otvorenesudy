module JusticeGovSk
  module Storage
    class SpecialHearingPage < JusticeGovSk::Storage::HearingPage
      def root
        @root ||= File.join super, 'special'
      end
    end
  end
end
