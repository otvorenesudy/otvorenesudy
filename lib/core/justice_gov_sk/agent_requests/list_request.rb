# encoding: utf-8

module JusticeGovSk
  module AgentRequests
    class ListRequest
      attr_accessor :page,
                    :per_page,
                    :hearing_or_decree_include_old,
                    :decree_form
                     

      def initialize
        @page = 1
        @per_page = 100
        @hearing_or_decree_include_old = false 
        @decree_form = nil        
      end
    end
  end
end
