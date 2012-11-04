module JusticeGovSk
  module Requests
    class CivilHearingListRequest < JusticeGovSk::Requests::ListRequest
      def url
        "#{JusticeGovSk::Requests::URL.base}/Stranky/Pojednavania/PojednavanieZoznam.aspx"
      end
    end
  end
end
