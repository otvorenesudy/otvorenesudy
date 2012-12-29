# encoding: utf-8

module JusticeGovSk
  module Request
    class List < JusticeGovSk::Request
      attr_accessor :page,
                    :per_page
      
      # TODO mv
      attr_accessor :include_old_hearings,
                    :decree_form

      def initialize
        @page     = 1
        @per_page = 100
        
        @include_old_hearings = nil 
        @decree_form          = nil
      end
    end
  end
end
