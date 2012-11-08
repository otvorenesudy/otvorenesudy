module JusticeGovSk
  module AgentRequests
    class SpecialHearingListRequest < JusticeGovSk::AgentRequests::ListRequest
      def url
        "#{JusticeGovSk::Requests::URL.base}/Stranky/Pojednavania/PojednavanieSpecZoznam.aspx"
      end
    end
  end
end
