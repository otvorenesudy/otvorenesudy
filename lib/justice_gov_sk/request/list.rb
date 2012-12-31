# encoding: utf-8

module JusticeGovSk
  class Request
    class List < JusticeGovSk::Request
      include Core::Request::List
      
      def initialize
        @page     = 1
        @per_page = 100
      end
    end
  end
end
