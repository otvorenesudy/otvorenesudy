module JusticeGovSk
  module AgentRequests
    class CourtListRequest < JusticeGovSk::AgentRequests::ListRequest
      def url
        "#{JusticeGovSk::Requests::URL.base}/Stranky/Sudy/SudZoznam.aspx"
      end
    end
  end
end
