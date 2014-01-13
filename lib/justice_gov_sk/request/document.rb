module JusticeGovSk
  class Request
    class Document < JusticeGovSk::Request
      attr_accessor :format

      def initialize
        @format = :pdf
      end

      def format=(value)
        raise "Unsupported format #{value}" if not [:pdf, :rtf, :doc].include?(value.to_sym)

        @format = value
      end
    end
  end
end
