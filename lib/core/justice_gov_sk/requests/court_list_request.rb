module JusticeGovSk
  module Requests
    class CourtListRequest < JusticeGovSk::Requests::ListRequest
      def url
        @url ||= "#{JusticeGovSk::Requests::URL.base}/Stranky/Sudy/SudZoznam.aspx"
      end
    end
  end
end
