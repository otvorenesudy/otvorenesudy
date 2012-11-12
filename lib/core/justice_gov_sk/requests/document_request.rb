module JusticeGovSk
  module Requests
    class DocumentRequest 
      attr_accessor :url,
                    :document_format
      
      def initialize
        @document_format = :pdf
      end

      def format=(value)
        raise "Unsupported format (#{value})" if not [:pdf, :rtf, :doc].include?(value.to_sym)
        
        @document_format = value
      end
    end
  end
end
