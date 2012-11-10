module JusticeGovSk
  module AgentRequests
    class DocumentRequest 
      attr_accessor :url,
                    :document_format
      
      ALLOWED_DOCUMENT_FORMATS = [:pdf, :rtf]

      def initialize
        @document_format = :pdf
      end

      def document_format=(format)
        format = format.to_sym if not format.is_a?(Symbol)
        raise "Unsupported format error (#{format})" if not ALLOWED_DOCUMENT_FORMATS.include?(format)
        @document_format = format
      end
    end
  end
end
