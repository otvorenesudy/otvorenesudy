module JusticeGovSk
  module Requests
    class CivilHearingListRequest < JusticeGovSk::Requests::HearingListRequest
      def url
        "#{JusticeGovSk::Requests::URL.base}/Stranky/Pojednavania/PojednavanieZoznam.aspx"
      end
    end
  end
end
