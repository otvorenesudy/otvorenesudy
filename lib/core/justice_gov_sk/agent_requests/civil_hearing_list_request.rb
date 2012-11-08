module JusticeGovSk
  module AgentRequests
    class CivilHearingListRequest < JusticeGovSk::AgentRequests::ListRequest
      def url
        "#{JusticeGovSk::Requests::URL.base}/Stranky/Pojednavania/PojednavanieZoznam.aspx"
      end
    end
  end
end
