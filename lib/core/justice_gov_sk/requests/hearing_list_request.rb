module JusticeGovSk
  module Requests
    class HearingListRequest < JusticeGovSk::Requests::ListRequest
      def initialize
        super

        @include_old_hearing_or_decree = true
      end

      def url
        "#{JusticeGovSk::Requests::URL.base}/Stranky/Pojednavania/PojednavanieZoznam.aspx"
      end
    end
  end
end
