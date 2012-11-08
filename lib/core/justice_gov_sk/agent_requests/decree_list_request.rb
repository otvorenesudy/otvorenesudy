module JusticeGovSk
  module AgentRequests
    class DecreeListRequest < JusticeGovSk::AgentRequests::ListRequest
      def url
        "#{JusticeGovSk::Requests::URL.base}/Stranky/Sudne-rozhodnutia/Sudne-rozhodnutia.aspx"
      end
    end
  end
end

