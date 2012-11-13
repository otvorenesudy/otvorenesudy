module JusticeGovSk
  module Requests
    class CriminalHearingListRequest < JusticeGovSk::Requests::HearingListRequest
      def url
        @url ||= "#{JusticeGovSk::Requests::URL.base}/Stranky/Pojednavania/PojednavanieTrestZoznam.aspx"
      end
    end
  end
end
