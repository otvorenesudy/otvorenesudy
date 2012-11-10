module JusticeGovSk
  module Requests
    class SpecialHearingListRequest < JusticeGovSk::Requests::HearingListRequest
      def url
        "#{JusticeGovSk::Requests::URL.base}/Stranky/Pojednavania/PojednavanieSpecZoznam.aspx"
      end
    end
  end
end
