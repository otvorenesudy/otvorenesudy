module JusticeGovSk
  class Request
    class List < JusticeGovSk::Request
      include Core::Request::List

      def initialize(options = {})
        @per_page = options[:per_page] || 100
        @page     = options[:page]     || 1
      end
    end
  end
end
