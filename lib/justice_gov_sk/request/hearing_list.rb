module JusticeGovSk
  class Request
    class HearingList < JusticeGovSk::Request::List
      def initialize
        super

        @include_old_hearings = true
      end
    end
  end
end
