module JusticeGovSk
  class Request
    class DecreeList < JusticeGovSk::Request::List
      attr_accessor :decree_form_code

      def initialize(options = {})
        super(options)

        @decree_form_code = options[:decree_form_code]
      end

      def self.url
        @url ||= "#{super}/Stranky/Sudne-rozhodnutia/Sudne-rozhodnutia.aspx"
      end
    end
  end
end
