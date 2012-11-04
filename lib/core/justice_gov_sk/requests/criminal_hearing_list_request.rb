module JusticeGovSk
  module Requests
    class CriminalHearingListRequest < JusticeGovSk::Requests::ListRequest
      def url
        "#{JusticeGovSk::Requests::URL.base}/Stranky/Pojednavania/PojednavanieTrestZoznam.aspx"
      end
    end
  end
end
