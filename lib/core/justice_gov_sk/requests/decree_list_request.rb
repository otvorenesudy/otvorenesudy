module JusticeGovSk
  module Requests
    class DecreeListRequest < JusticeGovSk::Requests::ListRequest
      def url
        "#{JusticeGovSk::Requests::URL.base}/Stranky/Sudne-rozhodnutia/Sudne-rozhodnutia.aspx"
      end
    end
  end
end

