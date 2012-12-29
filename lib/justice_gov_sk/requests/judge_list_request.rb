module JusticeGovSk
  module Requests
    class JudgeListRequest < JusticeGovSk::Requests::ListRequest
      def url
        @url ||= "#{JusticeGovSk::Requests::URL.base}/Stranky/Sudcovia/SudcaZoznam.aspx"
      end
    end
  end
end
