module Core
  class Request
    class List < Core::Request
      attr_accessor :page,
                    :per_page
      
      def initialize
        @page = 1
      end
    end
  end
end
