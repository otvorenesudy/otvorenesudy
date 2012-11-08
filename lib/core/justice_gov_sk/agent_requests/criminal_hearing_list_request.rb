module JusticeGovSk
  module AgentRequests
    class CriminalHearingListRequest < JusticeGovSk::AgentRequests::ListRequest
      def url
        "#{JusticeGovSk::Requests::URL.base}/Stranky/Pojednavania/PojednavanieTrestZoznam.aspx"
      end
    end
  end
end
