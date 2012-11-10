module JusticeGovSk
  module Requests
    class DocumentRequest 
      attr_accessor :url,
                    :format
      
      def initialize
        @format = :pdf
      end

      def format=(value)
        raise "Unsupported format (#{value})" if not [:pdf, :rtf].include?(value.to_sym)
        
        @format = format
      end
    end
  end
end
