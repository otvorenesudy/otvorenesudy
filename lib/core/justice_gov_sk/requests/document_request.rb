module JusticeGovSk
  module Requests
    class DocumentRequest 
      attr_accessor :url,
                    :document_format
      
      def initialize
        @document_format = :pdf
      end

      def format=(value)
        raise "Unsupported format (#{value})" if not [:pdf, :rtf].include?(value.to_sym)
        
        @document_format = format
      end
    end
  end
end
