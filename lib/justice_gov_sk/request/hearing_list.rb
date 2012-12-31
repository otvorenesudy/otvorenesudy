module JusticeGovSk
  class Request
    class HearingList < JusticeGovSk::Request::List
      attr_accessor :include_old_hearings
 
      def initialize
        super

        @include_old_hearings = true
      end
    end
  end
end
