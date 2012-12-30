module JusticeGovSk
  class Storage
    class CriminalHearingPage < JusticeGovSk::Storage::HearingPage
      def root
        @root ||= File.join super, 'criminal'
      end
    end
  end
end
