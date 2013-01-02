module JusticeGovSk
  class Request
    class DecreeList < JusticeGovSk::Request::List
      attr_accessor :decree_form

      def initialize(options = {})
        super(options)
        
        @decree_form = options[:decree_form] 
      end

      def url
        @url ||= "#{super}/Stranky/Sudne-rozhodnutia/Sudne-rozhodnutia.aspx"
      end
    end
  end
end
