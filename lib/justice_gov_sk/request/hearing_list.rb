module JusticeGovSk
  class Request
    class HearingList < JusticeGovSk::Request::List
      attr_accessor :include_old_hearings
 
      def initialize(options = {})
        super(options)

        @include_old_hearings = options[:include_old_hearings] || true
      end
    end
  end
end
