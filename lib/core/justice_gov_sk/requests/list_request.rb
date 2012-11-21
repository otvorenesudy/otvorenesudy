# encoding: utf-8

module JusticeGovSk
  module Requests
    class ListRequest
      attr_accessor :url,
                    :page,
                    :per_page
                    
      attr_accessor :include_old_hearing_or_decree,
                    :decree_form

      def initialize
        @page     = 1
        @per_page = 100
        
        @include_old_hearing_or_decree = true 
        @decree_form                   = nil
      end
    end
  end
end
