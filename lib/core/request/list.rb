module Core
  module Request
    module List
      include Core::Request
      
      attr_accessor :page,
                    :per_page
      
      def page
        @page ||= 1
      end
    end
  end
end
