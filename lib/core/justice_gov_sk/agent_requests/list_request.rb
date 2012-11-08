# encoding: utf-8

module JusticeGovSk
  module AgentRequests
    class ListRequest
      attr_accessor :page,
                    :per_page,
                    :include_old_records 

      def initialize
        @page = 1
        @per_page = 100
        @include_old_records = true
      end
    end
  end
end
