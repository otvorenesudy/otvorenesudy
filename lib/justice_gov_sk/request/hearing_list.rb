module JusticeGovSk
  module Requests
    class HearingListRequest < JusticeGovSk::Requests::ListRequest
      def initialize
        super

        @include_old_hearings = true
      end
    end
  end
end
