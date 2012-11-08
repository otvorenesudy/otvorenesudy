module JusticeGovSk
  module AgentRequests
    class JudgeListRequest < JusticeGovSk::AgentRequests::ListRequest
      def url
        "#{JusticeGovSk::Requests::URL.base}/Stranky/Sudcovia/SudcaZoznam.aspx"
      end
    end
  end
end
