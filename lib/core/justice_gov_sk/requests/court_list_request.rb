module JusticeGovSk
  module Requests
    class CourtListRequest < JusticeGovSk::Requests::ListRequest
      def url
        @url ||= "#{JusticeGovSk::Requests::URL.base}/Stranky/Sudy/SudZoznam.aspx"
      end

      def page
        @per_page == 100 ? nil : @page 
      end
    end
  end
end
